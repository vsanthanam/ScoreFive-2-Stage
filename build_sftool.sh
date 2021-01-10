swift build --package-path Tooling/sftool/ --configuration release
cp Tooling/sftool/.build/release/sftool sftool
echo "Built Tools @ Repo Root!"
