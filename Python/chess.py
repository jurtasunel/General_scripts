################################################################################
### This script recreates a simple chess game on a command line terminal.    ###
### Run it with "python3 chess.py" and follow the instructions on terminal.  ###
### Author: Josemari Urtasun Elizari                                         ###
### Last modified: Sept 23th, 2024                                           ###         
################################################################################


#################
# Create board. #
#################

# Create board as a matrix of 8 by 8 and fill it with empty spaces.
board = [""] * 8
for i in range(len(board)):

    board[i] = ["  "] * 8
# Make function to take in 8x8 matrix and return labeled board.
def print_board(board_matrix, current_player):

    print(" ### LEGEND ############################################\n" +
          " # P:Pawn, R:Rook, N:Knight, B:Bishop, Q:Queen, K:King #\n" +
          " # w = White player piece; b = Black player piece      #\n" + 
          " #######################################################\n")

    # Print standard board for white.
    if current_player == "White":

        # Loop through the rows.
        for i, row in enumerate(board_matrix):
            # Print row number (first chess row is 8 (list index 0 on python matrix) and last chess row is 1 (list index 7 on python matrix)).
            print(8-i, end = ": ")

            # Loop through the columns and print element on each row and column.
            for j, col in enumerate(row):
                print(col, end = " ")
            print("\n") # Add next line for each new row.

        # Print column labels at the end.
        print("   a  b  c  d  e  f  g  h")

    # Print reversed board for black.
    elif current_player == "Black":
    
        # Loop through rows indices.
        for i in range(len(board_matrix)):
            # Print row number (now first chess row is 1 (1 + python first index 0) and last chess row is 8 (7 + python last index 7)).
            print(i + 1, end = ": ")

            # Loop through column indices.
            for j in range(len(board[i])):
                # Get elements from board in reverse order.
                print(board[7-i][7-j], end = " ")
            print("\n")

        # Print reversed column labels at the end.
        print("   h  g  f  e  d  c  b  a")


##################
# Create pieces. #
##################

# Make two dictionaries with the initial possition of black and white pieces.
white_pieces_map = {"wP" : [(6,0), (6,1), (6,2), (6,3), (6,4), (6,5), (6,6), (6,7)],
                    "wR" : [(7,0), (7,7)],
                    "wN" : [(7,1), (7,6)],
                    "wB" : [(7,2), (7,5)],
                    "wQ" : [(7,3)],
                    "wK" : [(7,4)]}
black_pieces_map = {"bP" : [(1,0), (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7)],
                    "bR" : [(0,0), (0,7)],
                    "bN" : [(0,1), (0,6)],
                    "bB" : [(0,2), (0,5)],
                    "bQ" : [(0,3)],
                    "bK" : [(0,4)]}

# Place piedes on board.
def put_pieces(board):

    # Loop through the pieces dict elements as tuples of key-values with .items().
    for piece, squares in white_pieces_map.items():
        # Loop through each square.
        for square in squares:
            # Add each piece to its corresponding square.
            square_x, square_y = square[0], square[1]
            board[square_x][square_y] = piece

    # Repeat for black pieces.
    for piece, squares in black_pieces_map.items():
        for square in squares:
            square_x, square_y = square[0], square[1]
            board[square_x][square_y] = piece
put_pieces(board)


######################
# Utility functions. #
######################

# Parse the chess input format ("a2", "a4", "g8", "f6", etc) to python matrix format (board[6][0]], board[6][1], board[0][6], board[2][5], etc).
def parse_chessFormat_to_boardMatrix(input_str):

    # Make difctionary to store which index has each column.
    col_map = {"a":0, "b":1, "c":2, "d":3, "e":4, "f":5, "g":6, "h":7}
    # First element corresponds to the a-h column of starting square.
    start_x = col_map[input_str[0]]
    # Second element corresponds to the row number of tha starting square, but oposite numberation than programming (because 1st row in chess is last list on python matrix).
    start_y = 8 - int(input_str[1])
    # Reverse the input because it's in chess format (col-row) but board is a python matrix (row-col).
    start_x, start_y = start_y, start_x

    # Repeat for ending square
    end_x = col_map[input_str[3]]
    # Second number corresponds to the row, but oposite numberation than programming (because 1st row in chess is bottom row).
    end_y = 8 - int(input_str[4])
    # Reverse the input because it's in chess format (col-row) but board is a python matrix (row-col).
    end_x, end_y = end_y, end_x
    return start_x, start_y, end_x, end_y

# Check if input is correctly formated.
def is_wrong_input(input_str):

    # Make lists with all posibilities for rows and columns.
    cols = list("abcdefgh")
    rows = list("12345678")

    # Print if format is wrong, correct format must be a string of length 5 with a space on position 2.
    if len(input_str) != 5 or  list(input_str)[2] != " ":
        print("\n   # WRONG FORMAT! Please make sure to check the correct format above and try again.\n")
        return True
    
    # Print if coordinates are outside the board squares.
    elif list(input_str)[0] not in cols or \
        list(input_str)[1] not in rows or \
        list(input_str)[3] not in cols or \
        list(input_str)[4] not in rows:
        print("\n   # That square DOES NOT EXIST! Please pick existing squares (from a1 to h8) and try again.\n")
        return True
    
    # Start and end squares can't be the same.
    elif list(input_str)[0:2] == list(input_str)[3:5]:
        print("\n   # Start and end squares CAN'T BE THE SAME! Please pick different squares (from a1 to h8) and try again.\n")
        return True

# Decide which player plays depending on the turn number. White plays in odd turns, black plays on even turns.
def check_player(current_turn):

    current_player = ""
    # Check turn assigment with modulus. If turn is odd, modulus is 1, if it's even, modulus is 0.
    current_player = ""
    if current_turn % 2 == 1:
        current_player = "White"
    elif current_turn % 2 == 0:
        current_player = "Black"

    return current_player

# Check piece color.
def check_piece_color(square):
    
    # Pieces have two elements on the matrix board, first is "w" or "b" for color, then capital letter for piece type.
    if list(square)[0] == "w":
        color = "White"
    elif list(square)[0] == "b":
        color = "Black"
    return color

# Check if end square is empty.
def is_empty(square):
    
    # Empty squares have two spaces on the matrix board.
    if square == "  ":
        print("\n   # You can't select an EMPTY starting square, please try a different move.\n   'Can't get some if there's none...'\n")
        return True

# Check if end square is ocupied with a piece of the same color of the player.
def same_color_end_square(end_square, current_player):
    
    if (list(end_square)[0] == "w" and current_player == "White") or (list(end_square)[0] == "b" and current_player == "Black"):
        print("\n   # You selected an end square with a piece OF YOUR OWN, please try a different square.\n   'One is company, two is a crowd...'\n")
        return True

# Check if move is jumping over pieces.
def is_jumping(start_x, start_y, end_x, end_y, board):

    # Make list to store jumps.
    jumps = []

    # Movement on same row, x coordinate remains the same.
    if start_x == end_x:
        # Sort start and end coordinates to loop with range().
        sort_y = sorted([start_y, end_y])
        # Loop between next to start position and end positions minus one (range is open interval) and save any jumps found. This won't count starting and end square as jumps. 
        for y in range(sort_y[0] + 1, sort_y[1]):
            if board[start_x][y] != "  ":
                jumps.append(board[start_x][y])

    # Repeat for movement on same column, y coordinate remains the same.
    elif start_y == end_y:
        sort_x = sorted([start_x, end_x])
        for x in range(sort_x[0] + 1, sort_x[1]):
            if board[x][start_y] != "  ":
                jumps.append(board[x][start_y])

    # Diagonal movement, x and y coordinates move the same amount.
    elif abs(start_x - end_x) == abs(start_y - end_y):
        # Make ranges from start to end positions.
        if start_x < end_x:
            x = list(range(start_x, end_x))
        # Add negative step if first coordinate is higher than second coordinate. 
        else:
            x = list(range(start_x, end_x, -1))
        if start_y < end_y:
            y = list(range(start_y, end_y))
        else:
            y = list(range(start_y, end_y, -1))
        # Zip the x and y coordinates of all squares in the diagonal path in a list as tuples.
        path =  list(zip(x, y))
        # Loop through start and end squares (not counting the starting square) and save any jumps found. 
        for i in range(1, len(path)):
            i_square = path[i]
            if board[i_square[0]][i_square[1]] != "  ":
                jumps.append(board[i_square[0]][i_square[1]])

    # Check if any jumps were found.
    if len(jumps) > 0:
        print("\n   # Illegal move! That piece can't jump over other pieces.\n   'Look before you leap...'\n")
        return True
    
# Get list of positions of a piece type from one player.
def get_piece_position(piece_letter, player_color, board):

    piece_position = []

    # Make the piece string to search for on the board.
    if player_color == "White":
        piece_search = f"w{piece_letter}"
    elif player_color == "Black":
        piece_search = f"b{piece_letter}"

    # Loop through the board and store the coordinates of all occurences of that piece.
    for row in range(len(board)):
        for col in range(len(board[row])):
            if board[row][col] == piece_search:
                piece_position.append([row, col])

    return piece_position

# Check if end position of a piece produces a check.
def piece_check(piece, end_x, end_y, current_player, board):

    # Get position of oponent king.
    if current_player == "White":
        king_x = get_piece_position("K", "Black", board)[0][0]
        king_y = get_piece_position("K", "Black", board)[0][1]
    elif current_player == "Black":
        king_x = get_piece_position("K", "White", board)[0][0]
        king_y = get_piece_position("K", "White", board)[0][1]

    # Check if piece is giving check.
    if list(piece)[1] == "P":
        # If pawn connects with king by one diagonal square, it's check.
        if abs(end_x - king_x) == 1 and abs(end_y - king_y) == 1:
            if not (is_jumping(end_x, end_y, king_x, king_y, board)):
                print(("\n   # Pawn CHECK!\n"))
                return True
        
    if list(piece)[1] == "R":
        # If rook connects with king in straight line without jumps, it's check.
        if end_x == king_x or end_y == king_y:
            if not (is_jumping(end_x, end_y, king_x, king_y, board)):
                print("\n   # Rook CHECK!\n")
                return True
        
    if list(piece)[1] == "N":
        # If knight connects with king on L shape, it's check.
        if (abs(end_x - king_x) == 2 and abs(end_y - king_y)) or (abs(end_y - king_y) == 2 and abs(end_x - king_x)):
            print("\n   # Knight CHECK!\n")
            return True

    if list(piece)[1] == "B":
        # If bishop connects with king diagonally without jumps, it's check.
        if abs(end_x - king_x) == abs(end_y - king_y):
            if not (is_jumping(end_x, end_y, king_x, king_y, board)):
                print("\n   # Bishop CHECK!\n")
                return True

    if list(piece)[1] == "Q":
        # If queen connects with king without jumps, it's check.
        if end_x == king_x or end_y == king_y or abs(end_x - king_x) == abs(end_y - king_y):
            if not (is_jumping(end_x, end_y, king_x, king_y, board)):
                print("\n   # Queen CHECK!")
                return True

# Check if board position has a check for the current player.
def is_check(current_player, board):

    # Get positions of all enemy pieces that can give a check.
    R_check = get_piece_position("R", "White" if current_player == "Black" else "Black", board)
    N_check = get_piece_position("N", "White" if current_player == "Black" else "Black", board)
    B_check = get_piece_position("B", "White" if current_player == "Black" else "Black", board)
    Q_check = get_piece_position("Q", "White" if current_player == "Black" else "Black", board)
    P_check = get_piece_position("P", "White" if current_player == "Black" else "Black", board)
    # Get position of current player king.
    king_x = get_piece_position("K", "White" if current_player == "White" else "Black", board)[0][0]
    king_y = get_piece_position("K", "White" if current_player == "White" else "Black", board)[0][1]

    # Check if there is check between the kings position and any of those positions.
    for i in P_check:
        x, y = i[0], i[1]
        if abs(king_x - x) == 1 and abs(king_y - y) == 1:
            if not (is_jumping(king_x, king_y, x, y, board)):
                print("\n   # Illegal move! Your king would be in CHECK by a Pawn, please try again.\n")
                return True
            
    for i in R_check:
        x, y = i[0], i[1]
        if king_x == x or king_y == y:
            if not(is_jumping(king_x, king_y, x, y, board)):
                print("\n   # Illegal move! Your king would be in CHECK by a Rook, please try again.\n")
                return True
    
    for i in N_check:
        x, y = i[0], i[1]
        if (abs(king_x - x) == 2 and abs(king_y - y) == 1) or (abs(king_x - x) == 1 and abs(king_y - y) == 2):
                print("\n   # Illegal move! Your king would be in CHECK by a Knight, please try again.\n")
                return True
    
    for i in B_check:
        x, y = i[0], i[1]
        if abs(king_x - x) == abs(king_y - y):
            if not(is_jumping(king_x, king_y, x, y, board)):
                print("\n   # Illegal move! Your king would be in CHECK by a Bishop, please try again.\n")
                return True
    
    for i in Q_check:
        x, y = i[0], i[1]
        if king_x == x or king_y == y or abs(king_x - x) == abs(king_y - y):
            if not(is_jumping(king_x, king_y, x, y, board)):
                print("\n   # Illegal move! Your king would be in CHECK by the Queen, please try again.\n")
                return True


####################
# Pieces movement. #
####################

# Check illegal moves for pieces.
def pawn_illegal(start_x, start_y, end_x, end_y, current_player):

        # Check illegal for white.
        if current_player == "White":

            # Panws can't move backwards.
            if start_x - end_x < 1:
                print("\n   # Illegal move! Pawns can only move forward, please try again.\n")
                return True
            
            # On first move, pawns can move 1 or 2 forward.
            if start_x == 6:
                if start_x - end_x > 2 or start_x - end_x < 1:
                    print("\n   # Illegal move! Pawns can't move forward more than 2 squares on the first move, please try again.\n")
                    return True    
                
            # After first move, pawns only move 1 forward.
            elif start_x - end_x != 1:
                print("\n   # Illegal move! Pawns can't move forward more than 1 square after the first move, please try again.\n")
                return True
            
            # Pawns can't move one forward to capture.
            if start_y == end_y and list(board[end_x][end_y])[0] == "b":
                print("\n   # Illegal move! Pawns can't capture by moving forward, please try again.\n")
                return True

            # Can't move diagonally more than one position.
            if abs(start_y - end_y) > 1:
                print("\n   # Illegal move! Pawns can't move diagonally more than one move, please try again.\n")
                return True
            
            # Can move diagonally only for capturing.
            if abs(start_y - end_y) == 1:
                if list(board[end_x][end_y])[0] != "b":
                    print("\n   #  Illegal move! Pawn can only move diagonally to capture a piece, please try again.\n")
                    return True

        # Check illegal for black, same as white but invering order of operations and starting squares.
        if current_player == "Black":

            if end_x - start_x < 1:
                print("\n   # Illegal move! Pawns can only move forward, please try again.\n")
                return True
            
            if start_x == 1:
                if end_x - start_x > 2 or end_x - start_x < 1:
                    print("\n   # Illegal move! Pawns can't move forward more than 2 squares on the first move, please try again.\n")
                    return True    
                
            elif end_x - start_x != 1:
                print("\n   # Illegal move! Pawns can't move forward more than 1 square after the first move, please try again.\n")
                return True

            if start_y == end_y and list(board[end_x][end_y])[0] == "w":
                print("\n   # Illegal move! Pawns can't capture by moving forward, please try again.\n")
                return True
            
            if abs(start_y - end_y) > 1:
                print("\n   # Illegal move! Pawns can't move diagonally more than one move, please try again.\n")
                return True
            
            if abs(start_y - end_y) == 1:
                if list(board[end_x][end_y])[0] != "w":
                    print("\n   #  Illegal move! Pawn can only move diagonally to capture a piece, please try again.\n")
                    return True

def rook_illegal(start_x, start_y, end_x, end_y):

    # Check if move is not in a straight line.
    if start_x != end_x and start_y != end_y:
        print("\n   # Illegal move! Rooks can only move in a straight line, please try again.\n")
        return True

def bishop_illegal(start_x, start_y, end_x, end_y):

    # Check if move is not in diagonal line.
    if abs(start_x - end_x) != abs(start_y - end_y):
        print("\n   # Illegal move! Bishops can only move diagonally, please try again.\n")
        return True

def queen_illegal(start_x, start_y, end_x, end_y):

    # Check if move is not in a straigt or diagnoal line.
    if start_x != end_x and start_y != end_y and abs(start_x - end_x) != abs(start_y - end_y):
        print("\n   # Illegal move! Queens can only move straight or diagonally, please try again.\n")
        return True      

def knight_illegal(start_x, start_y, end_x, end_y):

    # Only allow movements where x moves 2 and y one, or vice versa.
    if abs(start_x - end_x) == 2:
        if abs(start_y - end_y) != 1:
            print("\n   # Illegal move! Knights move in an 'L' shape (2 squares up/down and 1 square left/right, or 2 squares left/right and 1 square up/down), please try again.\n")
            return True

    elif abs(start_y - end_y) == 2:
        if abs(start_x - end_x) != 1:
            print("\n   # Illegal move! Knights move in an 'L' shape (2 squares up/down and 1 square left/right, or 2 squares left/right and 1 square up/down), please try again.\n")
            return True

    else:
        print("\n   # Illegal move! Knights move in an 'L' shape (2 squares up/down and 1 square left/right, or 2 squares left/right and 1 square up/down), please try again.\n")
        return True

def king_illegal(start_x, start_y, end_x, end_y, current_player, board):

    # Only allow 1 square movements. 
    if abs(start_x - end_x) != 1 and abs(start_y - end_y) != 1:
        print("\n   # Illegal move! Kings can only move one position straight or diagonally (except for castling), please try again.\n")
        return True    
 

###############
# Make turns. #
###############

current_turn = 1
check_flag = False

# Loop through turns.
while (True):

    # Get current player and print corresponding board.
    current_player = check_player(current_turn)
    print(f"\nTurn {current_turn}: {current_player} moves! \n")
    print_board(board, current_player)
    print("")
    #print(f"\n    # You are in CHECK!\n" if check_flag == True else "")
    print('Make your move by typing the square of the piece you want to move,\nan empty space, and then the square you want to move it to\n(i.e.; "a2 a4", "g8 f6", etc).')

    # Keep asking for input squares until a legal move is provided.
    while (True):

        ########################################################
        # Get input move from terminal and check wrong inputs. #
        ########################################################

        input_move = input("Enter your move:").lower() 

        # Don't allow wrongly formated inputs.
        if is_wrong_input(input_move):
            continue

        # Get start and end squares from terminal.
        start_x, start_y, end_x, end_y = parse_chessFormat_to_boardMatrix(input_move)
        # Get selected piece and destination square.
        piece, end_square = board[start_x][start_y], board[end_x][end_y]

        # Don't allow selection of empty squares as a starting point.
        if is_empty(piece):
            continue
        
        # Don't allow selection of pieces from oponent player.
        if check_piece_color(piece) != current_player:
            print("\n   # You can't select a piece from your OPONENT, please try a different move.\n   'Stealing is wrong...'\n")
            continue

        # Don't allow end square to be occupied by a piece of the same player.
        if same_color_end_square(end_square, current_player):
            continue
    
        # Don't allow to jump over pieces, except for knights and king.
        if list(piece)[1] != "N" and list(piece)[1] != "K":
            if is_jumping(start_x, start_y, end_x, end_y, board):
                continue


        ###############################################
        # Forbide illegal moves for the chosen piece. #
        ###############################################
        
        if list(piece)[1] == "P":
            if pawn_illegal(start_x, start_y, end_x, end_y, current_player):
                continue
        
        elif list(piece)[1] == "R":
            if rook_illegal(start_x, start_y, end_x, end_y):
                continue

        elif list(piece)[1] == "N":
            if knight_illegal(start_x, start_y, end_x, end_y):
                continue

        elif list(piece)[1] == "B":
            if bishop_illegal(start_x, start_y, end_x, end_y):
                continue

        elif list(piece)[1] == "Q":
            if queen_illegal(start_x, start_y, end_x, end_y):
                continue

        elif list(piece)[1] == "K":
            if king_illegal(start_x, start_y, end_x, end_y, current_player, board):
                continue
        
        
        test_board = board
        test_board[start_x][start_y] = "  "
        test_board[end_x][end_y] = piece

        if is_check(current_player, test_board):
            print("STILL CHECK")
            continue

        # Break the while loop when none of the illegal actions functions returns a True. 
        break

    # Turn check flag on after a check.
    #if piece_check(piece, end_x, end_y, current_player, board):
        #check_flag = True
    
    # Update the board squares.
    board[start_x][start_y] = "  " # Change the square to an empty square.
    board[end_x][end_y] = piece # Add the piece to the new square.

    print(f"\n    ### End of turn {current_turn} ###")
    # Add next turn.
    current_turn += 1



# Check if piece is pin.
# Promotion.
# Castling and En Passant
# Checkmate end condition
