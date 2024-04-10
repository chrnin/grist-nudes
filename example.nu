#!/usr/bin/env nu
source grist.nu

let table_embarquement = grist_get "Embarquement"
let pending_records = ($table_embarquement.records | where fields.traite == non | length)
if $pending_records > 0 {
	print "---> send message to matrix"
} else {
	print "everything in order, do nothing"
}

