#!/usr/bin/env python3
"""
Script para converter imports relativos e absolutos com / para imports package
"""
import os
import re
from pathlib import Path

# Nome do package
PACKAGE_NAME = "medita_b_k"
LIB_DIR = Path(__file__).parent / "lib"

def calculate_absolute_path(file_path: Path, import_path: str) -> str:
    """
    Calcula o caminho absoluto a partir de um import relativo
    """
    if import_path.startswith('../'):
        # Import relativo
        current_dir = file_path.parent
        parts = import_path.split('/')

        # Conta quantos níveis subir
        levels_up = 0
        for part in parts:
            if part == '..':
                levels_up += 1
            else:
                break

        # Sobe os níveis necessários
        target_dir = current_dir
        for _ in range(levels_up):
            target_dir = target_dir.parent

        # Pega o resto do caminho
        rest_of_path = '/'.join(parts[levels_up:])

        # Calcula caminho relativo a lib/
        full_path = target_dir / rest_of_path
        relative_to_lib = full_path.relative_to(LIB_DIR)

        return f"package:{PACKAGE_NAME}/{relative_to_lib}"

    elif import_path.startswith('/'):
        # Import absoluto com /
        clean_path = import_path[1:]  # Remove /
        return f"package:{PACKAGE_NAME}/{clean_path}"

    return import_path

def convert_imports_in_file(file_path: Path):
    """
    Converte todos os imports relativos e absolutos com / em um arquivo
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    lines = content.split('\n')
    new_lines = []
    modified = False

    for line in lines:
        # Match para imports relativos ou com /
        match = re.match(r"^import '(\.\./.*?|/.*?)';", line)

        if match:
            import_path = match.group(1)

            # Pula se for import de package externo
            if import_path.startswith('package:'):
                new_lines.append(line)
                continue

            try:
                new_path = calculate_absolute_path(file_path, import_path)
                new_line = f"import '{new_path}';"

                # Preserva comentários inline
                if '//' in line:
                    comment = line.split('//', 1)[1]
                    new_line += f" //{comment}"

                new_lines.append(new_line)
                modified = True
                print(f"  {import_path} -> {new_path}")
            except Exception as e:
                print(f"  ⚠️  Erro ao converter {import_path}: {e}")
                new_lines.append(line)
        else:
            new_lines.append(line)

    if modified:
        new_content = '\n'.join(new_lines)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True

    return False

def find_dart_files_with_relative_imports():
    """
    Encontra todos os arquivos .dart com imports relativos ou absolutos com /
    """
    dart_files = []

    for root, dirs, files in os.walk(LIB_DIR):
        for file in files:
            if file.endswith('.dart'):
                file_path = Path(root) / file

                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Verifica se tem imports relativos ou com /
                if re.search(r"^import '(\.\./|/)", content, re.MULTILINE):
                    dart_files.append(file_path)

    return dart_files

def main():
    print("🔍 Procurando arquivos com imports relativos ou absolutos com /...\n")

    dart_files = find_dart_files_with_relative_imports()

    print(f"📝 Encontrados {len(dart_files)} arquivos para converter\n")

    if not dart_files:
        print("✅ Nenhum arquivo para converter!")
        return

    converted_count = 0

    for file_path in dart_files:
        relative_path = file_path.relative_to(LIB_DIR.parent)
        print(f"📄 {relative_path}")

        if convert_imports_in_file(file_path):
            converted_count += 1
            print("  ✅ Convertido")
        else:
            print("  ⏭️  Nenhuma conversão necessária")

        print()

    print(f"\n✨ Conversão concluída!")
    print(f"📊 {converted_count} de {len(dart_files)} arquivos modificados")
    print("\n⚠️  Execute 'flutter analyze' para verificar se há erros")

if __name__ == '__main__':
    main()
