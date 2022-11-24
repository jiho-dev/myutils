################################# 
# git alias command function
#


gitbr() {
	git branch -a
}

gitbr_refresh() {
	#git remote update --prune
	git remote update origin --prune
}


gitbr_new() {
	if [ "$#" -lt 1 ]; then
		echo "enter branch name"
		return
	fi
	git checkout -b $1
	git push -u origin $1
}

gitbr_del() {
	if [ "$#" -lt 1 ]; then
		echo "enter branch name"
		return
	fi
	git branch -D $1
}

gitbr_del_remote() {
	if [ "$#" -lt 1 ]; then
		echo "enter branch name"
		return
	fi
	git branch -D $1
	git push origin :$1
}

gitbr_ch() {
	if [ "$#" -lt 1 ]; then
		echo "enter branch name"
		return
	fi
	git checkout $1
}

gitst() {
	git status --untracked-files=no .
}

gitst_all() {
	git status .
}

gitco() {
	git checkout $1
}

git_conflict_clean() {
	git fetch --all
	git reset --hard origin/master
	git pull
}

git_gen_tag() {
	local tag_ver=$1

	if [ "${tag_ver}_" == "_" ]; then
		echo "specifing version string"
		echo "ex) $0 v1.2.3"
		exit 1
	fi

	echo "Tagging $tag_ver"

	git tag -a $tag_ver -m 'version $tag_ver'
	git push --tags

	#echo "run to push tags: git push upstream --tags"
}

