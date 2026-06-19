# Asset SEO, MD5, And Webflow Upload Rules

Created: 2026-05-23

## Webflow Requirements

- Asset API upload requires `fileName` and `fileHash`.
- `fileHash` must be the MD5 hash of the file contents.
- Filename should be under 100 characters including extension.
- Images should stay within Webflow image size limits.
- Alt text is set where images are used; filenames help context but do not replace alt text.

## Local Filename Policy

Use:

```text
project-prefix-descriptive-name-md5short.ext
```

Rules:

- lowercase
- ASCII
- hyphen separated
- no spaces
- no unsafe shell/URL characters
- max 100 characters
- keep extension lowercase

If source filenames are generic, use an SEO map before preparing assets. Supported fields:

```csv
file,seoName,alt,keywords,page,section,notes
```

Required from user only when semantic SEO matters and filenames are not descriptive:

- brand/project name
- target keyword
- page or section where the asset is used
- plain-language description
- desired alt text for important images

## MD5 Policy

- full MD5 goes in manifest as `md5`
- Webflow upload payload uses full MD5 as `fileHash`
- short MD5 suffix in filename is only for dedupe/cache traceability

## Images

Prepare:

- png
- jpg/jpeg
- gif
- svg
- webp
- avif

Flag:

- over 4MB
- non-descriptive source names
- missing suggested alt text
- Open Graph images converted to AVIF/WebP without fallback

## Videos

Prepare:

- mp4
- webm
- mov
- ogg/ogv
- m4v

Do not assume Webflow Assets API is the correct upload path for videos. Decide by use case:

- background video element
- CMS file field
- custom embed
- external hosting/CDN

## Local Commands

```bash
node run-local.mjs assets:prepare ./assets --prefix project-name --seo-map examples/asset-seo-map.example.csv
node run-local.mjs assets:upload --manifest artifacts/assets/latest.json --dry-run
```

Only run real upload after reviewing the manifest.
