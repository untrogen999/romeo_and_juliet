Stepfile to fix tagging *after* adding sex/house attributes to the play XML via XSLT.

Important expressions are shown inside backticks (inside two ``). Don't copy the backticks themselves.

1. Find `([^>\s])\n` to replace with `\1<br/>\n`.
2. Find `<line>` to replace with `<speech>`.
3. Find `</line>` to replace with `</speech>`.
4. Make the schema association point to `thePlay_MJB_fixed_tagging.rnc`
5. Save the result as a new file called `thePlay_MJB_fixed_tagging.xml`.
