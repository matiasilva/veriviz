import pyslang
import msgspec
from pathlib import Path

# NetSymbol
# VariableSymbol
# EnumValueSymbol
# FieldSymbol

MAX_DEPTH = 6
DATA_OUTPATH = Path("examples/circle_packing/")


class ModuleFinder:
    """Visitor that finds all module instances in a design. Inspired by slang-hier."""

    def __init__(self):
        # traversal variables
        self.root = None
        self.node_map = {}
        self.depth = MAX_DEPTH

    def __call__(self, node):
        if isinstance(node, pyslang.InstanceSymbol):
            if node.isModule:
                current = {
                    "name": f"{node.definition.name} ({node.name})",
                    "children": [],
                }
                if self.node_map:
                    parent = node.parentScope.containingInstance.parentInstance
                    self.node_map[parent]["children"].append(current)
                else:
                    self.root = current
                self.node_map[node] = current

                # control recursion
                self.depth -= 1
                if self.depth:
                    node.body.visit(self)
                self.depth += 1

                if not current["children"]:  # leaf node
                    del current["children"]
                    current["value"] = 1  # calculate later

                return pyslang.VisitAction.Skip

    def dump(self, outfile: str):
        outpath = DATA_OUTPATH / f"{outfile}.json"
        with open(outpath, "wb") as f:
            f.write(msgspec.json.encode(self.root))


class Counter:
    def __init__(self) -> None:
        self.total_count = 0  # tree weight
        self.signal_count = 0

    def __call__(self, node):
        self.total_count += 1
        if isinstance(node, (pyslang.NetSymbol, pyslang.VariableSymbol)):
            if node.kind == pyslang.SymbolKind.PackedStructType:
                pass  # FIXME
            self.signal_count += 1


source_manager = pyslang.SyntaxTree.getDefaultSourceManager()
loader = pyslang.SourceLoader(source_manager)

loader.addFiles("hdl/basic/*.sv")
loader.addFiles("hdl/intermediate/*.sv")
loader.addFiles("hdl/advanced/*.sv")

# loader.addSearchDirectories("include/")
# loader.addSearchExtension(".svh")

comp_options = pyslang.CompilationOptions()
# comp_options.topModules = {"example2_top"}

bag = pyslang.Bag([comp_options])

trees = loader.loadAndParseSources(bag)

comp = pyslang.Compilation(bag)
for tree in trees:
    comp.addSyntaxTree(tree)


diagnostics = comp.getAllDiagnostics()
if diagnostics:
    error_messages = []
    for diag in diagnostics:
        if diag.isError():
            error_messages.append(str(diag))
    if error_messages:
        raise Exception(f"Compilation errors: {'; '.join(error_messages)}")

root = comp.getRoot()
for instance in root.topInstances:
    visitor = ModuleFinder()
    instance.visit(visitor)

    leaf_nodes = {k: v for k, v in visitor.node_map.items() if "children" not in v}

    max_signal_count = 0
    for node, data in leaf_nodes.items():
        counter = Counter()
        node.visit(counter)
        data["value"] = counter.total_count
        data["intensity"] = counter.signal_count
        if counter.signal_count > max_signal_count:
            max_signal_count = counter.signal_count
    for data in leaf_nodes.values():
        data["intensity"] /= max_signal_count

    visitor.dump(instance.definition.name)
