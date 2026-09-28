import yaml
import sys

def test_rendered_manifest(file_path):
    print(f"Analizando manifiesto renderizado: {file_path}")
    try:
        with open(file_path, 'r') as f:
            docs = [doc for doc in yaml.safe_load_all(f) if doc]
        
        print(f"✓ Sintaxis YAML válida. Total de recursos procesados: {len(docs)}")
        for doc in docs:
            kind = doc.get('kind', 'Unknown')
            name = doc.get('metadata', {}).get('name', 'Unknown')
            print(f"   - Resource: {kind:15} | Name: {name}")
    except Exception as e:
        print(f"✗ Error al validar YAML: {e}")
        sys.exit(1)

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "manifests-rendered-prod.yaml"
    test_rendered_manifest(path)
