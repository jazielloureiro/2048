if exists('g:loaded_2048')
	finish
endif

command -nargs=* Start2048 call game2048#main(<f-args>)

let g:loaded_2048 = 1
