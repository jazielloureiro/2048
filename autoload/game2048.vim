function! game2048#main(...)
	call s:createBuffer()

	let l:game = s:createGameDict(a:000)

	call s:drawBoardStructure(l:game.rows, l:game.cols)

	while l:game.input != "q"
		call s:drawBoard(l:game.board)

		let l:game.input = nr2char(getchar())

		if l:game.input =~ 'h\|j\|k\|l'
			call s:mergeNumbers(l:game, l:game.merge[l:game.input])

			call s:move(l:game, l:game.move[l:game.input])
		endif

		if l:game.is_move
			call s:addNumberToBoard(l:game)
			let l:game.is_move = 0
		endif

		if s:isGameOver(l:game)
			call append(line("$"), "Game over!")
			break
		elseif l:game.biggest >= l:game.limit
			call append(line("$"), "You win!")
			break
		endif
	endwhile

	if l:game.input != "q"
		call append(line("$"), "Press any key to exit.")
		call s:drawBoard(l:game.board)
		call getchar()
	endif

	bdelete!
endfunction

function! s:createBuffer()
	if filewritable(expand('%'))
		write
	endif

	edit! 2048

	setlocal filetype=2048 buftype=nofile noswapfile 
		\ nocursorcolumn nocursorline nolist
		\ nowrap nospell
endfunction

function! s:createGameDict(args)
	let l:game = #{rows: 4, cols: 4, limit: 2048,
		\ biggest: 4, is_move: 0, input: ""}

	call s:matchArgs(l:game, a:args)

	let l:game.board = s:createBoard(l:game.rows, l:game.cols)

	let l:game.available_squares = l:game.rows * l:game.cols

	call s:addNumberToBoard(l:game)
	call s:addNumberToBoard(l:game)

	let l:game.merge = {}

	let l:game.merge["h"] = {
		\ "rows": range(l:game.rows),
		\ "cols": range(l:game.cols - 1),
		\ "inc": 1,
		\ "limit": l:game.cols - 1}

	let l:game.merge["j"] = {
		\ "rows": range(l:game.rows - 1, 1, -1),
		\ "cols": range(l:game.cols),
		\ "inc": -1,
		\ "limit": 0}

	let l:game.merge["k"] = {
		\ "rows": range(l:game.rows - 1),
		\ "cols": range(l:game.cols),
		\ "inc": 1,
		\ "limit": l:game.rows - 1}

	let l:game.merge["l"] = {
		\ "rows": range(l:game.rows),
		\ "cols": range(l:game.cols - 1, 1, -1),
		\ "inc": -1,
		\ "limit": 0}

	let l:game.move = {}

	let l:game.move["h"] = {
		\ "rows": range(l:game.rows),
		\ "cols": range(1, l:game.cols - 1),
		\ "inc": -1,
		\ "limit": 1}

	let l:game.move["j"] = {
		\ "rows": range(l:game.rows - 2, 0, -1),
		\ "cols": range(l:game.cols),
		\ "inc": 1,
		\ "limit": l:game.rows - 2}

	let l:game.move["k"] = {
		\ "rows": range(1, l:game.rows - 1),
		\ "cols": range(l:game.cols),
		\ "inc": -1,
		\ "limit": 1}

	let l:game.move["l"] = {
		\ "rows": range(l:game.rows),
		\ "cols": range(l:game.cols - 2, 0, -1),
		\ "inc": 1,
		\ "limit": l:game.cols - 2}

	return l:game
endfunction

function! s:matchArgs(game, args)
	for l:i in a:args
		if l:i =~ '^rows=\d\+$' || l:i =~ '^cols=\d\+$'
			let l:num = str2nr(l:i[5:])

			if l:num >= 2 && l:num <= 20
				if l:i =~ '^rows=\d\+$'
					let a:game.rows = l:num
				else
					let a:game.cols = l:num
				endif
			endif
		elseif l:i =~ '^limit=\d\+$'
			let l:num = str2nr(l:i[6:])

			if l:num > 4
				let a:game.limit = l:num
			endif
		endif
	endfor
endfunction

function! s:createBoard(rows, cols)
	let l:cols = []
	for l:i in range(a:cols)
		let l:cols += [0]
	endfor

	let l:board = []
	for l:i in range(a:rows)
		let l:board += [[]]
		let l:board[l:i] = copy(l:cols)
	endfor

	return l:board
endfunction

function! s:addNumberToBoard(game)
	let l:position = rand() % a:game.available_squares + 1
	let l:pos_count = 0

	for l:i in range(a:game.rows)
		for l:j in range(a:game.cols)
			if a:game.board[l:i][l:j] == 0
				let l:pos_count += 1

				if l:pos_count == l:position
					let a:game.board[l:i][l:j] = rand() % 10 == 0? 4 : 2
					let a:game.available_squares -= 1
					return
				endif
			endif
		endfor
	endfor
endfunction

function! s:drawBoardStructure(rows, cols)
	call s:drawLine(
		\ #{id: 1, cols: a:cols, start: "╔", mid: "╦", end: "╗"}
		\ )

	for l:i in range(2, a:rows * 2)
		if l:i % 2 == 0
			call setline(l:i, "")
		else
			call s:drawLine(
				\ #{id: l:i, cols: a:cols,
				\   start: "╠", mid: "╬", end: "╣"}
				\ )
		endif
	endfor

	call s:drawLine(
		\ #{id: a:rows * 2 + 1, cols: a:cols,
		\   start: "╚", mid: "╩", end: "╝"}
		\ )
endfunction

function! s:drawLine(line)
	let l:aux = a:line.start

	for l:i in range(a:line.cols - 1)
		let l:aux .= "══════" . a:line.mid
	endfor

	let l:aux .= "══════" . a:line.end

	call setline(a:line.id, l:aux)
endfunction

function! s:drawBoard(board)
	let l:line_id = 2

	for l:i in a:board
		let l:line = "║"

		for l:j in l:i
			if l:j > 9999
				let l:line .= printf(" %.3s. ║", l:j)
			elseif l:j != 0
				let l:line .= printf(" %4d ║", l:j)
			else
				let l:line .= "      ║"
			endif
		endfor

		call setline(l:line_id, l:line)
		let l:line_id += 2
	endfor

	redraw
endfunction

function! s:mergeNumbers(game, rg)
	for l:i in a:rg.rows
		for l:j in a:rg.cols
			if a:game.board[l:i][l:j] != 0 && a:game.input =~ 'h\|l'
				for l:k in range(l:j + a:rg.inc, a:rg.limit, a:rg.inc)
					if a:game.board[l:i][l:j] == a:game.board[l:i][l:k]
						let a:game.board[l:i][l:j] *= 2
						let a:game.board[l:i][l:k] = 0

						if a:game.board[l:i][l:j] > a:game.biggest
							let a:game.biggest = a:game.board[l:i][l:j] 
						endif

						let a:game.available_squares += 1
						let a:game.is_move = 1
						break
					elseif a:game.board[l:i][l:k] != 0
						break
					endif
				endfor
			elseif a:game.board[l:i][l:j] != 0
				for l:k in range(l:i + a:rg.inc, a:rg.limit, a:rg.inc)
					if a:game.board[l:i][l:j] == a:game.board[l:k][l:j]
						let a:game.board[l:i][l:j] *= 2
						let a:game.board[l:k][l:j] = 0

						if a:game.board[l:i][l:j] > a:game.biggest
							let a:game.biggest = a:game.board[l:i][l:j] 
						endif

						let a:game.available_squares += 1
						let a:game.is_move = 1
						break
					elseif a:game.board[l:k][l:j] != 0
						break
					endif
				endfor
			endif
		endfor
	endfor
endfunction

function! s:move(game, rg)
	for l:i in a:rg.rows
		for l:j in a:rg.cols
			if a:game.board[l:i][l:j] != 0 && a:game.input =~ 'h\|l'
				for l:k in range(l:j, a:rg.limit, a:rg.inc)
					if a:game.board[l:i][l:k + a:rg.inc] == 0
						let l:aux = a:game.board[l:i][l:k]
						let a:game.board[l:i][l:k] = a:game.board[l:i][l:k + a:rg.inc]
						let a:game.board[l:i][l:k + a:rg.inc] = l:aux
						let a:game.is_move = 1
					else
						break
					endif
				endfor
			elseif a:game.board[l:i][l:j] != 0
				for l:k in range(l:i, a:rg.limit, a:rg.inc)
					if a:game.board[l:k + a:rg.inc][l:j] == 0
						let l:aux = a:game.board[l:k][l:j]
						let a:game.board[l:k][l:j] = a:game.board[l:k + a:rg.inc][l:j]
						let a:game.board[l:k + a:rg.inc][l:j] = l:aux
						let a:game.is_move = 1
					else
						break
					endif
				endfor
			endif
		endfor
	endfor
endfunction

function! s:isGameOver(game)
	if a:game.available_squares > 0
		return 0
	endif

	for l:i in range(a:game.rows - 1)
		for l:j in range(a:game.cols - 1)
			if a:game.board[l:i][l:j] == a:game.board[l:i + 1][l:j]
				return 0
			elseif a:game.board[l:i][l:j] == a:game.board[l:i][l:j + 1]
				return 0
			endif
		endfor

		if a:game.board[l:i][a:game.cols - 1] == a:game.board[l:i + 1][a:game.cols - 1]
			return 0
		endif
	endfor

	for l:j in range(a:game.cols - 1)
		if a:game.board[a:game.rows - 1][l:j] == a:game.board[a:game.rows - 1][l:j + 1]
			return 0
		endif
	endfor

	return 1
endfunction
