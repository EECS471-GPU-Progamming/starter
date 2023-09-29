# /bin/bash

# Updates the account in the given tarballs run_tests file
# Overwrites the submit file kept in the tarball with the submit file located adjacent to update.sh

prev_account=eecs471w23_class
cur_account=eecs471f23_class

for folder in */; do
    name=$(basename $folder)
    echo $name
    if [ $name == "final_project" ]; then
        continue
    fi
    sed -i "s/$prev_account/$cur_account/" $name/run_tests
done

sed -i "s/$prev_account/$cur_account/" shared.mk