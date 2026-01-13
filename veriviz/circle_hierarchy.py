import pyslang
import msgspec


class ModuleFinder:
    """Visitor that finds all module instances in a design. Inspired by slang-hier."""

    def __init__(self):
        self.modules = {}

        self.parent_module = self.modules
        self.depth = 0

    def __call__(self, node):
        if isinstance(node, pyslang.InstanceSymbol):
            if node.isModule:
                current_module = {}
                current_module["name"] = node.definition.name

                self.parent_module["children"].append(current_module)
                self.current_depth += 1
                for member in node.body:
                    member.visit(self)
                else:
                    current_module["value"] = 1

                self.current_depth -= 1

                return pyslang.VisitAction.Skip
        return pyslang.VisitAction.Advance

    def dump(self):
        with open("data.json", "wb") as f:
            f.write(msgspec.json.encode(self.modules))


source_manager = pyslang.SyntaxTree.getDefaultSourceManager()
loader = pyslang.SourceLoader(source_manager)

loader.addFiles("../examples/circle_packing/rtl/*.sv")

# loader.addSearchDirectories("include/")
# loader.addSearchExtension(".svh")

# comp_options = pyslang.CompilationOptions()
# comp_options.topModules.add("top")

# bag = pyslang.Bag([comp_options])
bag = pyslang.Bag()

trees = loader.loadAndParseSources(bag)

comp = pyslang.Compilation(bag)
for tree in trees:
    comp.addSyntaxTree(tree)

root = comp.getRoot()
top = root.topInstances[0]
visitor = ModuleFinder()
top.visit(visitor)

for mod in visitor.modules:
    print(mod.name, mod.definition.name)
