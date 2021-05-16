function! s:main()
	call s:createBuffer()

	let l:board = s:createBoard()

	call setline(1, 'Hello World!')
	redraw
	call getchar()

	bdelete!
endfunction

function! s:createBuffer()
	if filewritable(expand('%'))
		write
	endif

	edit! 2048
endfunction

function! s:createBoard()
	const l:boardSize = 3

	let l:cols = []
	for l:i in range(0, l:boardSize)
		let l:cols += [0]
	endfor

	let l:board = []
	for l:i in range(0, l:boardSize)
		let l:board += [[]]
		let l:board[l:i] = copy(l:cols)
	endfor

	return l:board
endfunction

call s:main()
