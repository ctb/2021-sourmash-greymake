QUERY='wort-sra.one-match.sig'
INDEX_DIR='wort-sra.zips'
PICKLIST_PREFIX='search/'
OUTDIR='out'

INDEX_LIST, = glob_wildcards(f"{INDEX_DIR}/{{i}}.zip")
print(INDEX_LIST)

rule all:
    input:
        expand(f"{OUTDIR}/{{idx}}.search.csv", idx=INDEX_LIST)

rule select_to_picklists:
    params:
        index_dir = INDEX_DIR,
        prefix = PICKLIST_PREFIX,
    shell: """
        ../2021-sourmash-mom/mom-select-to-picklists.py \
            {params.index_dir}/*.db --output-prefix {params.prefix} -k 31 --dna
    """

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
