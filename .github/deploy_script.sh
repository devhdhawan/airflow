
# Install the latest version of Astro CLI
curl -sSL install.astronomer.io | sudo bash -s
# Determine if only DAG files have changes
files=$(git diff --name-only $(git rev-parse HEAD~1) -- .)
dags_only=1
for file in $files; do
  if [[ $file != "$DAG_FOLDER"* ]]; then
    echo "$file is not a dag, triggering a full image build"
    dags_only=0
    break
  fi
done
# If only DAGs changed deploy only the DAGs in your 'dags' folder to your Deployment
if [ $dags_only == 1 ]
then
    astro deploy --dags
fi
# If any other files changed build your Astro project into a Docker image, push the image to your Deployment, and then push and DAG changes
if [ $dags_only == 0 ]
then
    astro deploy
fi