# grist-nudes
example repository running nu-shell scripts interacting with grist with github actions

## installing
1. You need to install nu-shell, see https://www.nushell.sh/
2. You need a grist token, see 
3. In order to work locally, you need to setup .env, see .env.example

## using grist-nudes
Start your own script by 
```
#!/usr/bin/env nu
source grist.nu

# here you go
get_grist Embarquement
```

## setup your actions
see .github/workflows/nu.yml

## secret management
never ever push you gist secrets in .env file, use github repository secrets instead
