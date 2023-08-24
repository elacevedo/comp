from decaf_ast import AST


class Parser:
    def __init__(self, data):
        self.data = data
        self.keywords = ['void', 'int', 'double', 'bool', 'string', 'null', 'for', 'while', 'if', 'else', 'return',
                         'break', 'Print', 'ReadInteger', 'ReadLine']
        self.controls = ['for', 'while', 'if', 'else', 'return', 'break', 'Print', 'ReadInteger', 'ReadLine']
        self.types = ['void', 'int', 'double', 'bool', 'string', 'null']
        self.operators = ['+', '-', '*', '/', '%', '<', '<=', '>', '>=', '=', '==', '!=', '&&', '||', '!', ';']
        self.puncuation = [',', '.', '(', ')', '{', '}']
        self.comments = ['//', '/*', '*/']
        self.node = None

    def separator(self):
        prev_node = None
        punc = ['(', ')', '{', '}']
        for i in punc:
            split_index = self.data.index(i) + 1

        #while loop to decide splits
        #inside loop to transverse tree
        #split_index = self.data.index('{') + 1
        #self.node = AST("Program:", None)
        #prev_node = self.node
        #new node
        #self.node = AST(self.data[:split_index], prev_node)
        #prev_node.setChild('left', self.node)
        #new node; eval code; decide it is right of root
        #self.node = AST(self.data[split_index:], prev_node)
        #prev_node.setChild('right', self.node)

    def getTree(self):
        self.separator()
#        last = self.node.right.data
        while self.node.parent != None:
            self.node = self.node.parent

        visited_all = False
        while not visited_all:
            if not self.node.visited:
                print(self.node.data)
                self.node.visited = True
            if self.node.parent is not None and self.node.left is None and self.node.right is None:
                self.node = self.node.parent
            elif self.node.parent is None and self.node.left is not None and self.node.right is not None:
                if self.node.left.visited and self.node.right.visited:
                    visited_all = True
                else:
                    if self.node.left is not None and not self.node.left.visited:
                        self.node = self.node.left
                    elif self.node.right is not None and not self.node.right.visited:
                        self.node = self.node.right
