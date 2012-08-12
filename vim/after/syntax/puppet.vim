setlocal iskeyword=:,@,48-57,_,192-255
setlocal spell
setlocal tags=tags;/

syntax match puppetComment "\s*#.*$" contains=puppetTodo,@Spell
