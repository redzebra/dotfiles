"let b:bash_is_sh=1			" highlight bash syntax
"let b:highlight_balanced_quotes=1	" highlight single quotes inside double
"let b:highlight_function_names=1

"syn region shSingleQuote matchgroup=shOperator start=+'+ end=+'+ contains=shStringSpecial
"syn region shDoubleQuote matchgroup=shOperator start=+"+ skip=+\\"+ end=+"+ contains=@shDblQuoteList,shStringSpecial

setlocal shiftwidth=2
setlocal tabstop=2
