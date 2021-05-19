function! s:main()
	call s:createBuffer()

	let l:board = s:createBoard()

	let l:game = {
		\ "available_squares": 14,
		\ "input": ""}

	call s:drawBoardStructure()

	while l:game.input != "q"
		call s:drawBoard(l:board)

		let l:game.input = nr2char(getchar())

		if l:game.input == "h"
			call s:moveLeft(l:board, l:game)
		elseif l:game.input == "j"
			call s:moveDown(l:board, l:game)
		elseif l:game.input == "k"
			call s:moveUp(l:board, l:game)
		elseif l:game.input == "l"
			call s:moveRight(l:board, l:game)
		endif

		call s:addNumberToBoard(l:board, l:game.available_squares)
		let l:game.available_squares -= 1
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

function! s:moveLeft(board, game)
	for l:i in range(4)
		for l:j in range(3)
			if a:board[l:i][l:j] != 0
				for l:k in range(l:j + 1, 3)
					if a:board[l:i][l:j] == a:board[l:i][l:k]
						let a:board[l:i][l:j] *= 2
						let a:board[l:i][l:k] = 0
						let a:game.available_squares += 1
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

function! s:moveDown(board, game)
	for l:i in range(4)
		for l:j in range(3, 1, -1)
			if a:board[l:j][l:i] != 0
				for l:k in range(l:j - 1, 0, -1)
					if a:board[l:j][l:i] == a:board[l:k][l:i]
						let a:board[l:j][l:i] *= 2
						let a:board[l:k][l:i] = 0
						let a:game.available_squares += 1
						break
					elseif a:board[l:k][l:i] != 0
						break
					endif
				endfor
			endif
		endfor
	endfor

	for l:i in range(4)
		for l:j in range(2, 0, -1)
			if a:board[l:j][l:i] != 0
				while l:j < 3
					if a:board[l:j + 1][l:i] == 0
						let l:aux = a:board[l:j][l:i]
						let a:board[l:j][l:i] = a:board[l:j + 1][l:i]
						let a:board[l:j + 1][l:i] = l:aux
						let l:j += 1
					else
						break
					endif
				endwhile
			endif
		endfor
	endfor
endfunction

function! s:moveUp(board, game)
	for l:i in range(4)
		for l:j in range(3)
			if a:board[l:j][l:i] != 0
				for l:k in range(l:j + 1, 3)
					if a:board[l:j][l:i] == a:board[l:k][l:i]
						let a:board[l:j][l:i] *= 2
						let a:board[l:k][l:i] = 0
						let a:game.available_squares += 1
						break
					elseif a:board[l:k][l:i] != 0
						break
					endif
				endfor
			endif
		endfor
	endfor

	for l:i in range(4)
		for l:j in range(1, 3)
			if a:board[l:j][l:i] != 0
				while l:j > 0
					if a:board[l:j - 1][l:i] == 0
						let l:aux = a:board[l:j][l:i]
						let a:board[l:j][l:i] = a:board[l:j - 1][l:i]
						let a:board[l:j - 1][l:i] = l:aux
						let l:j -= 1
					else
						break
					endif
				endwhile
			endif
		endfor
	endfor
endfunction

function! s:moveRight(board, game)
	for l:i in range(4)
		for l:j in range(3, 1, -1)
			if a:board[l:i][l:j] != 0
				for l:k in range(l:j - 1, 0, -1)
					if a:board[l:i][l:j] == a:board[l:i][l:k]
						let a:board[l:i][l:j] *= 2
						let a:board[l:i][l:k] = 0
						let a:game.available_squares += 1
						break
					elseif a:board[l:i][l:k] != 0
						break
					endif
				endfor
			endif
		endfor
	endfor

	for l:i in range(4)
		for l:j in range(2, 0, -1)
			if a:board[l:i][l:j] != 0
				while l:j < 3
					if a:board[l:i][l:j + 1] == 0
						let l:aux = a:board[l:i][l:j]
						let a:board[l:i][l:j] = a:board[l:i][l:j + 1]
						let a:board[l:i][l:j + 1] = l:aux
						let l:j += 1
					else
						break
					endif
				endwhile
			endif
		endfor
	endfor
endfunction

call s:main()
