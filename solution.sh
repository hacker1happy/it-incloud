# challange:
# write code which would take the content from cert.txt and separate it into two files: tls.crt and tls.key

#! usr/bin/bash
cert=0
key=0
while IFS= read -r line
do
    ## if line contains "BEGIN CERTIFICATE"/ "metadata with tls.cert" then we are to in the cert file
    if [[ $line == *"tls.crt"* ]]
    then
        cert=1
        IFS=':' #setting space as delimiter  
        read -ra ADDR <<<"$line" #reading str as an array as tokens separated by IFS  
        echo ${ADDR[2]} >> tls.crt
        continue
    fi

    if [[ $cert == 1 ]]
    then
        if [[ $line == *-*[A-Z]*-* ]]
        then
            cert=0
            if [[ $line == *"tls.key"* ]]
            then
                key=1
                IFS=':' #setting space as delimiter  
                read -ra arr <<<"$line" #reading str as an array as tokens separated by IFS 
                echo ${arr[1]} >> tls.key

                IFS='tls.key'
                read -ra ADDR <<<"${arr[0]}" 
                echo ${ADDR[0]} >> tls.crt
                continue
            fi
        fi
        echo $line >> tls.crt
    fi

    if [[ $key == 1 ]]
    then
            if [[ $line == *"END OPENSSH TESTKEY"* ]]
            then
                key=0
                IFS=']' #setting space as delimiter  
                read -ra arr <<<"$line" #reading str as an array as tokens separated by IFS 
                echo ${arr[0]} >> tls.key
                continue
            fi
        echo $line >> tls.key
    fi
done < cert.txt
