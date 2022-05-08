#!/bin/bash
    
# This bash script is used to backup a user's home directory to /tmp/.
    
function backup {
	user=$1   
    output=/tmp/${user}_home_$(date +%Y-%m-%d_%H%M%S).tar.gz
    
    function total_files {
    	find $1 -type f | wc -l
    }
    
    function total_directories {
    	find $1 -type d | wc -l
    }
    
    function total_archived_directories {
    	tar -tzf $1 | grep  /$ | wc -l
    }
    
    function total_archived_files {
    	tar -tzf $1 | grep -v /$ | wc -l
    }
    
    directories_to_archive=(/home/$user/Documents /home/$user/Downloads /home/$user/Pictures /home/$user/Desktop /home/$user/Music /home/$user/Videos)

    tar -czf $output ${directories_to_archive[@]};

    for directory in ${directories_to_archive[@]}; do
    let src_directories+=$( total_directories $directory )
    done

    for directory in $directories_to_archive; do
    let src_files+=$( total_files $directory )
    done

    arch_files=$( total_archived_files $output )
    arch_directories=$( total_archived_directories $output )
    
    echo "########## $user ##########"
    echo "Files to be included: $src_files"
    echo "Directories to be included: $src_directories"
    echo "Files archived: $arch_files"
    echo "Directories archived: $arch_directories"
    
    echo "Backup of $input completed!"
    echo "Details about the output backup file:"
    ls -l $output

}

if [ $# -eq 0 ]; then
	backup $(whoami)
elif [ $# -eq 1 ]; then
    backup $1 
else
echo "Wrong number of arguments."
fi
