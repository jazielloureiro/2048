function! s:main()
	call s:createBuffer()

	let l:board = s:createBoard()

	call s:drawBoardStructure()

	let l:input = "h"
	let l:available_squares = 14
	while l:input != "q"
		call s:drawBoard(l:board)

		let l:input = nr2char(getchar())
		echo l:input

		if l:input == "h"
			call s:moveLeft(l:board)
		elseif l:input == "j"
		elseif l:input == "k"
		elseif l:input == "l"
		endif

		call s:addNumberToBoard(l:board, l:available_squares)
		let l:available_squares -= 1
	endwhile

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

	call s:addNumberToBoard(l:board, 16)
	call s:addNumberToBoard(l:board, 15)

	return l:board
endfunction

function! s:addNumberToBoard(board, available_squares)
	let l:position = rand() % a:available_squares + 1
	let l:pos_count = 0

	for l:i in range(4)
		for l:j in range(4)
			if a:board[l:i][l:j] == 0
				let l:pos_count += 1

				if l:pos_count == l:position
					let a:board[l:i][l:j] = rand() % 10 == 0? 4 : 2
					return
				endif
			endif
		endfor
	endfor
endfunction

function! s:drawBoardStructure()
	call setline(1, "╔══════╦══════╦══════╦══════╗")
	call setline(2, "║      ║      ║      ║      ║")
	call setline(3, "╠══════╬══════╬══════╬══════╣")
	call setline(4, "║      ║      ║      ║      ║")
	call setline(5, "╠══════╬══════╬══════╬══════╣")
	call setline(6, "║      ║      ║      ║      ║")
	call setline(7, "╠══════╬══════╬══════╬══════╣")
	call setline(8, "║      ║      ║      ║      ║")
	call setline(9, "╚══════╩══════╩══════╩══════╝")
endfunction

function! s:drawBoard(board)
	for [l:i, l:j] in [[0, 2], [1, 4], [2, 6], [3, 8]]
		let l:line = "║ "

		for l:k in range(4)
			if a:board[l:i][l:k] != 0
				let l:line .= printf("%4d", a:board[l:i][l:k]) . " ║ "
			else
				let l:line .= "    " . " ║ "
			endif
		endfor

		call setline(l:j, l:line)
	endfor

	redraw
endfunction

function! s:moveLeft(board)
	for l:i in range(4)
		for l:j in range(3)
			if a:board[l:i][l:j] != 0
				for l:k in range(l:j + 1, 3)
					if a:board[l:i][l:j] == a:board[l:i][l:k]
						let a:board[l:i][l:j] *= 2
						let a:board[l:i][l:k] = 0
						break
					elseif a:board[l:i][l:k] != 0
						break
					endif
				endfor
			endif
		endfor
	endfor

	for l:i in range(4)
		for l:j in range(1, 3)
			if a:board[l:i][l:j] != 0
				while l:j > 0
					if a:board[l:i][l:j - 1] == 0
						let l:aux = a:board[l:i][l:j]
						let a:board[l:i][l:j] = a:board[l:i][l:j - 1]
						let a:board[l:i][l:j - 1] = l:aux
						let l:j -= 1
					else
						break
					endif
				endwhile
			endif
		endfor
	endfor
endfunction

call s:main()
