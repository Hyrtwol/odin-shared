package documentation

import "core:c/libc"
import "core:fmt"
import "core:odin/ast"
import doc "core:odin/doc-format"
import "core:odin/parser"
import "core:os"
import "core:strings"

Example_Test :: struct {
	entity_name:       string,
	package_name:      string,
	example_code:      []string,
	expected_output:   []string,
	skip_output_check: bool,
}

g_header: ^doc.Header
g_bad_doc: bool
g_examples_to_verify: [dynamic]Example_Test
g_path_to_odin: string

array :: proc(a: $A/doc.Array($T)) -> []T {
	return doc.from_array(g_header, a)
}

str :: proc(s: $A/doc.String) -> string {
	return doc.from_string(g_header, s)
}

common_prefix :: proc(strs: []string) -> string {
	if len(strs) == 0 {
		return ""
	}
	n := max(int)
	for str in strs {
		n = min(n, len(str))
	}

	prefix := strs[0][:n]
	for str in strs[1:] {
		for len(prefix) != 0 && str[:len(prefix)] != prefix {
			prefix = prefix[:len(prefix) - 1]
		}
		if len(prefix) == 0 {
			break
		}
	}
	return prefix
}

errorf :: proc(format: string, args: ..any) -> ! {
	fmt.eprintf("%s ", os.args[0])
	fmt.eprintf(format, ..args)
	fmt.eprintln()
	os.exit(1)
}

main :: proc() {
	fmt.println("# shared")

	if len(os.args) != 2 {
		errorf("expected path to odin executable")
	}
	g_path_to_odin = os.args[1]
	data, data_err := os.read_entire_file("all.odin-doc", context.allocator)
	if data_err != nil {
		errorf("unable to read file: all.odin-doc")
	}
	defer delete(data)

	err: doc.Reader_Error
	g_header, err = doc.read_from_bytes(data)
	switch err {
	case .None:
	case .Header_Too_Small:
		errorf("file is too small for the file format")
	case .Invalid_Magic:
		errorf("invalid magic for the file format")
	case .Data_Too_Small:
		errorf("data is too small for the file format")
	case .Invalid_Version:
		errorf("invalid file format version")
	}
	pkgs := array(g_header.pkgs)
	entities := array(g_header.entities)

	path_prefix: string
	{
		fullpaths: [dynamic]string
		defer delete(fullpaths)

		for pkg in pkgs[1:] {
			append(&fullpaths, str(pkg.fullpath))
		}
		path_prefix = common_prefix(fullpaths[:])
	}

	for pkg in pkgs[1:] {
		package_name := str(pkg.name)
		fullpath := str(pkg.fullpath)
		path := strings.trim_prefix(fullpath, path_prefix)

		//fmt.println("pkg:", fullpath, path)
		//trimmed_path := strings.trim_prefix(path, "Odin/")
		//fmt.println("pkg:", package_name, path, trimmed_path)

		entries_array := array(pkg.entries)

		if strings.has_prefix(path, "Odin/core/") {
			continue
		}
		/*
		if strings.has_prefix(trimmed_path, "sys") {
			continue
		}
		if strings.contains(trimmed_path, "/_") {
			continue
		}
		*/

		// fmt.println("pkg:", package_name, path)
		fmt.println()
		fmt.printfln("## %s", package_name)
		fmt.println()
		fmt.println("path:", path)
		fmt.println()

		types := array(g_header.types)

		for entry in entries_array {
			entity: doc.Entity = entities[entry.entity]
			docs := str(entity.docs)
			entity_name := str(entity.name)
			entity_type := types[entity.type]
			entity_type_name := str(entity_type.name)

			#partial switch entity.kind {
				case .Type_Name:
					fmt.printfln("Type_Name: %-50s %s", entity_name, entity_type_name)
				case .Constant:
					fmt.printfln("Constant:  %-50s %s", entity_name, entity_type_name)
				case .Variable:
					fmt.printfln("Variable:  %-50s %s", entity_name, entity_type_name)
				case .Procedure:
					fmt.printfln("Procedure: %s", entity_name)
				case:
					fmt.printfln("Todo:      %-50s %-16v %s", entity_name, entity.kind, entity_type_name)
					//fmt.printfln("Todo:      %#v", entity)
			}

			//fmt.printfln("  entity: %-16v %-50s %s", entity.kind, entity_name, entity_type_name)

			// fmt.println()
			// fmt.printfln("### %s", entity_name)
			// fmt.println()
			// fmt.printfln("  kind: %-16v type: '%s'", entity.kind, entity_type_name)

			/*
			find_and_add_examples(
				docs = str(entity.docs),
				package_name = str(pkg.name),
				entity_name = str(entity.name),
			)
			*/
		}
	}
	/*
	write_test_suite(g_examples_to_verify[:])
	if g_bad_doc {
		errorf("We created bad documentation!")
	}

	if ! run_test_suite() {
		errorf("Test suite failed!")
	}
	*/
	fmt.println("Examples verified")
}

find_and_add_examples :: proc(docs: string, package_name: string, entity_name: string) {
	if docs == "" {
		return
	}
	fmt.println(#procedure, docs, package_name, entity_name)
}
