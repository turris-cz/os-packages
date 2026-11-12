# Convert the table of 24-bit OUIs in epan/manuf-data.c of Wireshark to
# lines of oui.db, "<prefix>|<vendor>". For example
#
#     { { 0x00, 0x9C, 0x02 }, "HewlettPacka", "Hewlett Packard" },
#
# gives "009C02|Hewlett Packard". The short name is used only when there is
# no full one.

# Return the value of the first C string literal in s and set REST to what
# follows it. Wireshark escapes only quotes and backslashes in the names, any
# other escape sequence makes the build fail.
function string_literal(s,    i, c, value) {
	REST = ""
	i = index(s, "\"")
	if (!i)
		return ""
	value = ""
	for (i++; i <= length(s); i++) {
		c = substr(s, i, 1)
		if (c == "\\") {
			i++
			c = substr(s, i, 1)
			if (c != "\\" && c != "\"")
				unknown_escape = "\\" c
		} else if (c == "\"") {
			REST = substr(s, i + 1)
			return value
		}
		value = value c
	}
	return value
}

/global_manuf_oui24_table\[\]/ {
	table = 1
	next
}

table && /^};/ {
	exit
}

table && /^[ \t]*\{ *\{ *0x/ {
	line = $0
	sub(/^[ \t]*\{ *\{ */, "", line)
	prefix = line
	sub(/ *\}.*/, "", prefix)
	gsub(/0x|[ ,]/, "", prefix)
	short = string_literal(line)
	full = string_literal(REST)
	if (prefix ~ /^[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]$/) {
		print toupper(prefix) "|" (full != "" ? full : short)
		count++
	}
}

# e.g. the format changed, rather than a wrong or almost empty database
END {
	if (unknown_escape != "") {
		print "Unknown escape sequence " unknown_escape > "/dev/stderr"
		exit 1
	}
	if (count < 30000) {
		print "Only " (count + 0) " OUIs found" > "/dev/stderr"
		exit 1
	}
}
