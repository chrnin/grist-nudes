#!/usr/bin/env nu
use grist.nu

let table_messages = grist records "Messages" 
print $table_messages.records.fields
let pending_records = ($table_messages.records | where fields.sent == null | length)
if $pending_records > 0 {
	print $"($pending_records) messages pending ---> I may send them"
} else {
	print "everything in order, do nothing"
}

