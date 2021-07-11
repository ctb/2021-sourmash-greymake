QUERY='wort-sra.one-match.sig'
INDEX_DIR='wort-sra.zips'
PICKLIST_PREFIX='search/'
OUTDIR='out'

INDEX_LIST, = glob_wildcards(f"{INDEX_DIR}/{{i}}.zip")
print(INDEX_LIST)

rule all:
    input:
        expand(f"{OUTDIR}/{{idx}}.search.csv", idx=INDEX_LIST)

rule search_idx:
    input:
        query = QUERY,
        index = f"{INDEX_DIR}/{{idx}}.zip",
        manifest = f"{PICKLIST_PREFIX}{{idx}}.zip.csv",
    output:
        out = f"{OUTDIR}/{{idx}}.search.csv"
    shell: """
        sourmash search --containment {input.query} {input.index} \
            --picklist {input.manifest}::manifest -o {output.out}
    """
