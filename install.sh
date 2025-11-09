#!/usr/bin/env bash
#
PROJECT_DIR_NAME=e2-nextflow
pushd .
if [ ! -d "~/$PROJECT_DIR_NAME" ]; then
    cd
    
    echo "Cloning model-bouncer repo...."
    git clone https://github.com/Cytoreason/e2-nextflow.git
    cd $PROJECT_DIR_NAME
    git pull 

    echo "Installing nextflow with conda"
    conda install nextflow -c bioconda
    echo "Installing VS Code Server Python extensions..."
    /tmp/code-server/bin/code-server --install-extension nextflow.nextflow
    /tmp/code-server/bin/code-server --install-extension ms-python.debugpy
    echo "Python extensions for VS Code Server have been installed successfully!"

    VSCODE_DOT_DIR=.vscode
    mkdir -p "$VSCODE_DOT_DIR"

    VSCODE_SETTINGS_JSON="$VSCODE_DOT_DIR"/settings.json

    if [ ! -f "$VSCODE_SETTINGS_JSON" ]; then
        echo "Creating $VSCODE_SETTINGS_JSON ..."
        cat <<EOF > "$VSCODE_SETTINGS_JSON"
{
    "python.envFile": "\${workspaceFolder}/.env",
    "python.defaultInterpreterPath": "$(poetry env info --path)/bin/python",
    "python.terminal.activateEnvironment": true,
}

EOF
    fi
fi
export TOWER_ACCESS_TOKEN=`gcloud secrets versions access latest --secret=TOWER_ACCESS_TOKEN`
popd
