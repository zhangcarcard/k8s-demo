#!/bin/bash

## 到项目跟目录执行该脚本
ST_COMMIT_MSG=".stCommitMsg"

COMMIT_MSG="commit-msg"
GIT_HOOKS=".git/hooks"
GIT_COMMIT_MSG="$GIT_HOOKS/$COMMIT_MSG"
FIRST_DO="0"
installGitRules() {
    whiteFile() {
        cat >>$ST_COMMIT_MSG <<EOF
<type>(<scope>) : <subject>
<body>
<footer>
EOF
    }

    pushd ~/
    if [ ! -f $ST_COMMIT_MSG ]; then
        echo "$ST_COMMIT_MSG file not exist"
        touch .stCommitMsg
        whiteFile
    else
        COPY_FILE="${ST_COMMIT_MSG}_backup"
        cp -P ~/$ST_COMMIT_MSG ~/$COPY_FILE
        : >$ST_COMMIT_MSG
        whiteFile
    fi
    popd


    writeCommitMsg() {
        cat >>.git/hooks/commit-msg <<EOF
#!/bin/bash
TIP_MESSAGE='
<type>(<scope>) : <subject>\n
<body>\n
<footer>\n
\n
#type 本次修改功能类型\n
    .feat :新功能\n
    .fix :修复bug\n
    .opt :优化(optimize) 图片压缩, 文件删除等\n
    .ci : 版本号升级、branchConfig修改、scrip/podinfo.rb等发布相关修改\n
    .test :增加测试\n

    .refactor :某个已有功能重构\n
    .docs :文档改变\n
    .style :代码格式改变\n
    .revert :撤销上一次的 commit (revert 命令自动生成)\n
\n
#scope :用来说明此次修改的影响范围\n
    .all :表示影响面大 ，如修改了网络框架  会对真个程序产生影响\n
    .loation :表示影响小，某个小小的功能\n
    .module :表示会影响某个模块 如登录模块、首页模块 、用户管理模块等等\n
\n
#subject: 用来简要信息描述本次改动\n
\n
#body :具体的修改信息 应该尽量详细\n
\n
#footer :备注:  文档链接、bug id、设计文档\n
'

MSG=\$(awk '{printf("%s",\$0)}' \$1)
if [[ \$MSG =~ ^(feat|fix|opt|ci|test|refactor|docs|style|revert)\(.*\):.*$ ]]; then
    echo -e " commit success!"
else
    echo -e \MSG
    echo -e " Error: the commit message is irregular "
    echo -e " Error: type must be one of feat|fix|opt|ci|test|refactor|docs|style|revert"
    echo -e ' eg: feat(租房): 详情页增加无尽流'
    echo '详细文档👇👇👇'
    echo -e \$TIP_MESSAGE
    exit 1
fi
EOF
    }

    if [ ! -d $GIT_HOOKS ]; then
        pushd .git
        mkdir hooks
        mkfile -n 0b hooks/commit-msg
        popd
        writeCommitMsg
    else
        if [ ! -f $GIT_COMMIT_MSG ]; then

            mkfile -n 0b $GIT_COMMIT_MSG
            writeCommitMsg
        else

            COPY_FILE="${COMMIT_MSG}_backup"
            cp -P $GIT_COMMIT_MSG $GIT_HOOKS/$COPY_FILE
            : >$GIT_COMMIT_MSG
            writeCommitMsg
        fi
    fi

    sudo chmod 777 $GIT_COMMIT_MSG
    if [ $FIRST_DO != '0' ]; then
        echo 'Configuration is successful! ��👏👏 '
        echo 'Restart Sourcetree then submit your changes!'
    fi
}

uninstallGitRules() {
    if [ ! -f $GIT_COMMIT_MSG ]; then
        echo "Don't have git commit message rules to remove!"
    else
        rm $GIT_COMMIT_MSG
        echo "remove git commit message rules success!"
    fi

    pushd ~/
    if [ ! -f $ST_COMMIT_MSG ]; then
        echo "$ST_COMMIT_MSG file not exist, Don't have git commit rules template to remove!"
    else
        rm $ST_COMMIT_MSG
        echo "remove git commit message rules template success!"
    fi
    popd

}

install() {
    installGitRules
    FIRST_DO="1"
    installGitRules
}

if [ $# == 0 ]; then
    install
    exit
fi
for i in "$*"; do

    if [ $i == "install" ]; then
        install
    elif [ $i == "uninstall" ]; then
        uninstallGitRules
    else
        install
    fi
done

