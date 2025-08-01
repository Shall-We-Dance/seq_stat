# NGS Data Stat Pipeline

A lightweight, parallelized shell script for computing checksums and generating summary statistics for next-generation sequencing (NGS) `FASTQ` files. Designed for simplicity and speed in preprocessing and quality checking workflows.

## Features

- Automatically compresses `.fq`/`.fastq` files using `pigz` (parallel gzip) or `gzip`
- Calculates both **MD5** and **SHA256** checksums for `.fastq.gz`/`.fq.gz` files
- Generates comprehensive statistics using [`seqkit`](https://bioinf.shenwei.me/seqkit/)
- Multi-threaded performance: automatically uses half of available CPU threads
- Supports all common FASTQ file extensions (`.fq`, `.fastq`, compressed or uncompressed)
- Works recursively in current directory and all subdirectories

## Requirements

- Linux/Unix environment with `bash`
- [SeqKit](https://bioinf.shenwei.me/seqkit/) installed and available in `PATH`
- Optional:
  - [`pigz`](https://zlib.net/pigz/) for faster parallel compression (fallback to `gzip` if not available)

## Usage

```bash
bash seq_stat.sh
```


Simply run the script in the root directory containing your FASTQ files. It will:

1. Compress any `.fq` or `.fastq` files if not already compressed
2. Generate:

   * `md5_checksums.txt` with MD5 checksums
   * `sha_checksums.txt` with SHA256 checksums
   * `seqkit_stats.txt` with detailed sequence statistics

All operations are performed recursively from the current directory.

## Output Files

* `md5_checksums.txt`: MD5 hashes for integrity verification
* `sha_checksums.txt`: SHA256 hashes (alternative checksum method)
* `seqkit_stats.txt`: Summary statistics per file (read counts, base content, quality, etc.)

### Example Output: `seqkit_stats.txt`

Below is an anonymized example of the `seqkit_stats.txt` output generated by this pipeline:

```tsv
file                    format  type    num_seqs        sum_len     min_len  avg_len  max_len  Q1  Q2  Q3  sum_gap  N50  Q20(%)  Q30(%)  AvgQual  GC(%)
sample1_1.fastq.gz      FASTQ   DNA     34,973,421      2,514,238,284  30     71.9     73  72  73  73        0   73   94.02   91.26    25.56    45.75
sample1_2.fastq.gz      FASTQ   DNA     34,973,421      2,616,856,075  30     74.8     76  75  76  76        0   76   93.05   90.04    24.86    45.61
sample2_1.fastq.gz      FASTQ   DNA     38,849,428      2,792,050,765  30     71.9     73  72  73  73        0   73   93.74   91.35    25.37    45.94
sample2_2.fastq.gz      FASTQ   DNA     38,849,428      2,905,165,018  30     74.8     76  75  76  76        0   76   92.16   89.36    24.37    45.66
sample3_1.fastq.gz      FASTQ   DNA     35,496,907      2,550,701,969  30     71.9     73  72  73  73        0   73   93.96   91.16    25.52    46.37
sample3_2.fastq.gz      FASTQ   DNA     35,496,907      2,655,700,000  30     74.8     76  75  76  76        0   76   92.61   89.50    24.63    46.44
sample4_1.fastq.gz      FASTQ   DNA     39,770,507      2,857,175,123  30     71.8     73  72  73  73        0   73   93.72   91.33    25.36    46.50
```

This table includes key metrics such as read counts, base content, quality scores, and GC content.

## How to Verify Checksums

After file compression and hash generation, you can verify the integrity of your `FASTQ` files using the following commands:

### Verify MD5 Checksums

```bash
md5sum -c md5_checksums.txt
```

This checks each file listed in `md5_checksums.txt` and reports `OK` if the checksum matches, or `FAILED` otherwise.

### Verify SHA256 Checksums

```bash
sha256sum -c sha_checksums.txt
```

This command performs the same validation using SHA256 hashes listed in `sha_checksums.txt`.

## Notes

* Compression and statistics generation are executed in parallel for improved speed.
* Ensure `seqkit` is installed prior to running the script.

## License

MIT License

## Contact

For suggestions or issues, please submit a GitHub issue.
