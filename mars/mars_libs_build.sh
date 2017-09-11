# not project dependency
if [[ ${BUILT_PRODUCTS_DIR} == ${SRCROOT}* ]]
then
    exit
fi

XCODE_PROJ_SUFFIX=".xcodeproj"
BEGIN_REFER_SECTION="Begin PBXReferenceProxy section"
END_REFER_SECTION="End PBXReferenceProxy section"
LIB_BEGIN="path = "
LIB_END=";"

getChildProjectFolder()
{
    is_filereference_section=false
    i=0

    while read line
    do
        if [[ $line == *$END_REFER_SECTION* ]]
        then
            break
        fi


        if [[ $is_filereference_section == true && $line == *$LIB_BEGIN* ]]
        then
            line=${line#*"$LIB_BEGIN"}
                libs[i]=${line%"$LIB_END"*}
                let i=$i+1
        fi

        if [[ $line == *$BEGIN_REFER_SECTION* ]]
        then
            is_filereference_section=true
        fi


    done < ${SRCROOT}/${PROJECT_NAME}${XCODE_PROJ_SUFFIX}/project.pbxproj
    echo  ${libs[*]}
}

childer_project_libs=`getChildProjectFolder`


cd ${BUILT_PRODUCTS_DIR}

files=(`ls *.a`)

cpu_info=`lipo -info libcomm.a`
cpu_info=(${cpu_info#*"are: "})
curr_path=`pwd`


for ci in ${cpu_info[*]}
do
    if [[ ! -d "${BUILT_PRODUCTS_DIR}/$ci" ]]
    then
        mkdir -p "${BUILT_PRODUCTS_DIR}/$ci"
    fi
done


for ci in ${cpu_info[*]}
do
    i=0
    for f in ${files[*]}
    do
        if echo ${childer_project_libs[*]} | grep -w $f
        then
            lipo "${BUILT_PRODUCTS_DIR}/"$f -thin $ci -output "${BUILT_PRODUCTS_DIR}/$ci/$f"

            folder=${f%".a"}
            if [[ ! -d "${BUILT_PRODUCTS_DIR}/$ci/$folder" ]]
            then
                mkdir -p "${BUILT_PRODUCTS_DIR}/$ci/$folder"
            fi
            cd "${BUILT_PRODUCTS_DIR}/$ci/$folder"
            ar -x "${BUILT_PRODUCTS_DIR}/$ci/$f"

            for o in `ls "${BUILT_PRODUCTS_DIR}/$ci/$folder"/*.o`
            do
                obj_files[i]=$o
                let i=$i+1
            done
        fi
    done

    libtool -static -o ${BUILT_PRODUCTS_DIR}/$ci/${EXECUTABLE_NAME} ${obj_files[*]}
done

i=0
for ci in ${cpu_info[*]}
do
    cpu_executable_files[i]=${BUILT_PRODUCTS_DIR}/$ci/${EXECUTABLE_NAME}
    let i=$i+1
done

lipo -create ${cpu_executable_files[*]} -output ${BUILT_PRODUCTS_DIR}/${EXECUTABLE_NAME}

for ci in ${cpu_info[*]}
do
    if [[ -d "${BUILT_PRODUCTS_DIR}/$ci" ]]
    then
        rm -rf "${BUILT_PRODUCTS_DIR}/$ci"
    fi
done
