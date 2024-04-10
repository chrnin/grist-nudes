if  not (["GRIST_APIKEY", "GRIST_ORG", "GRIST_WORKSPACE", "GRIST_DOC", "GRIST_DOMAIN"]|all {|c| $c in ($env|columns)}) {
    echo "error: env is not set (see .env.example)"
    exit 1
}

def init_grist [] {
    let apikey = ['Authorization', $'Bearer ($env.GRIST_APIKEY)']
    let org_id = http get --headers $apikey $"https://($env.GRIST_DOMAIN)/api/orgs"|where name == $env.GRIST_ORG|get 0 | get "id"
    let workspace_id = http get --headers $apikey $"https://($env.GRIST_DOMAIN)/api/orgs/($org_id)/workspaces"|where name == $env.GRIST_WORKSPACE|get "id"|get 0
    let doc_id = http get --headers $apikey $"https://($env.GRIST_DOMAIN)/api/workspaces/($workspace_id)" |get "docs"|get "id"|get 0
    let tables = http get --headers $apikey $"https://($env.GRIST_DOMAIN)/api/docs/($doc_id)/tables"
    let grist = {
       apikey: $apikey,
       org_id: $org_id,
       workspace_id: $workspace_id,
       doc_id: $doc_id,
       tables: $tables,
    }
    return $grist
}

let grist = init_grist

let grist_url = $"https://($env.GRIST_DOMAIN)/api"

def grist_table_url [table_name: string] {
    return $"($grist_url)/docs/($grist.doc_id)/tables/($table_name)/records"
}

def grist_get [table_name: string] {
    let url = grist_table_url $table_name
    return (http get --headers $grist.apikey $url)
}

def grist_patch [table_name: string, records: record<records: list<record>>] {
    let url = grist_table_url $table_name
    http patch --raw --content-type application/json --headers $grist.apikey $url $records
}