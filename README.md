
To update *all* the plugins: 
`git submodule foreach git pull origin master`

On a new machine, register the merge driver that keeps the local `lazy-lock.json` on conflicting pulls (see `.gitattributes`):
`git config merge.ours.driver true`
