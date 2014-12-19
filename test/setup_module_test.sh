#!/bin/bash

get_name (){
    echo $(python -c 'import json; print json.load(open("'$1'package.json"))["name"]')
}

setup_submodule (){
    for dep in $(cat test/dep_modules.txt); do
        mname=$(basename $dep | sed 's/.git//g')
        git clone --depth=15 $dep ~/$mname
        rmname=$(get_name ~/$mname/)
        cp -r  ~/$mname/module ~/shinken/modules/$rmname
        [ -f ~/$mname/requirements.txt ] && pip install -r ~/$mname/requirements.txt
    done
    # we need the livestatus test config files to be in shinken test config dir:
    cp -r ~/mod-livestatus/test/etc/* ~/shinken/test/etc/
}

name=$(get_name)

pip install pycurl
pip install coveralls
git clone https://github.com/naparuba/shinken.git ~/shinken

[ -f test/dep_modules.txt ] && setup_submodule
[ -f requirements.txt ] && pip install -r requirements.txt
[ -f test/requirements.txt ] && pip install -r test/requirements.txt

# if we have test config files we probably also need them in the shinken/test directory :
[ -d test/etc ] && cp -r test/etc ~/shinken/test/

# copy our module package to the shinken modules directory:
cp -r module ~/shinken/modules/$name
# and make a link to it from the test/modules directory:
ln -sf ~/shinken/modules/ ~/shinken/test/modules
