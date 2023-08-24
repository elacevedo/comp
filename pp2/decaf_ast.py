class AST:
    def __init__(self, data, parent):
        self.keywords = ['void', 'int', 'double', 'bool', 'string', 'null', 'for', 'while', 'if', 'else', 'return',
                         'break', 'Print', 'ReadInteger', 'ReadLine']
        self.controls = ['for', 'while', 'if', 'else', 'return', 'break', 'Print', 'ReadInteger', 'ReadLine']
        self.types = ['void', 'int', 'double', 'bool', 'string', 'null']
        self.operators = ['+', '-', '*', '/', '%', '<', '<=', '>', '>=', '=', '==', '!=', '&&', '||', '!', ';']
        self.puncuation = [',', '.', '(', ')', '{', '}']
        self.comments = ['//', '/*', '*/']
        self.parent = parent
        self.left = None
        self.right = None
        self.data = data
        self.syntax_type = None
        self.type = None
        self.identifier = None
        self.visited = False

    def setChild(self, direction, AST):
        if direction == 'left':
            self.left = AST
        else:
            self.right = AST

    def setSyntaxType(self, syntaxType):
        self.syntax_type = syntaxType
        for i in self.types:
            if i in self.data and '{' in self.data:
                self.syntax_type = 'FnDecl:'
                break
            elif i in self.data and ';' in self.data:
                self.syntax_type = 'VarDecl:'

    def setType(self):
        pass

    def getParent(self):
        return self.parent

    def getChild(self, direction):
        if direction == 'left':
            return self.left
        else:
            return self.right

    def getData(self):
        return self.data
