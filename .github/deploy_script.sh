
# pip install -r requirements.txt
# Install the latest version of Astro CLI
curl -sSL install.astronomer.io | sudo bash -s
# Determine if only DAG files have changes

# cd $RELEASE_PRIMARYARTIFACTSOURCEALIAS
# echo "cd into $RELEASE_PRIMARYARTIFACTSOURCEALIAS"

# git checkout ${RELEASE_ARTIFACTS__GITREPO__SOURCEVERSION:0:7}
# echo "checkout commit ${RELEASE_ARTIFACTS__GITREPO__SOURCEVERSION:0:7}"

files=$(git diff --name-only $(git rev-parse HEAD~1) -- .)
dags_only=1
echo "DEPLOYMENT ID $DEPLOYMENT_ID"

for file in $files; do

  if [[ $file != "dags/"* ]]; then
    echo "$file is not a dag, triggering a full image build"
    dags_only=0
    break
  fi
done
# If only DAGs changed deploy only the DAGs in your 'dags' folder to your Deployment
if [ $dags_only == 1 ]
then
    astro deploy --dags cm973jsjf1hec01mu1ojv79mo
fi
# If any other files changed build your Astro project into a Docker image, push the image to your Deployment, and then push and DAG changes
if [ $dags_only == 0 ]
then
    astro deploy cm973jsjf1hec01mu1ojv79mo
fi