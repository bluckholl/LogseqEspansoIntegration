# Logseq Espanso Integration
Scripts for generating Espanso yaml configuration out of Logseq blocks

## Motivation
- Espanso yaml configuration is somewhat not that user friendly (well, as opposed to logseq blocks for sure..)
- Logseq can hold variety of items types (journal, tasks, etc) including snippets (mostly logseq templatess and code snippets inside code blocks to be copied with "Copy Code" plugin)

Why not combine them and mark those "snippets" blocks with special espanso attributes and generate yaml match files?
For day to day snippets cross applications (and platforms) thanks to Espanso!

You hear right - This project providing scripts for generating espanso yaml configuration from logseq blocks!
## Demo

![Demo](https://github.com/bluckholl/LogseqEspansoIntegration/assets/2509820/7a0303ce-257a-4b43-bd92-ba3156af7c78)



## Usage

### Two structure types are supported
#### inline replacement
```
espanso-regex:: <espanso trigger> 
espanso-label:: <espanso label, optional, to be displayed with espanso search bar>
espanso-filename:: <yaml filename (.yml ending is optional) , optional, default to logseq.yml>
espanso-replace:: `<replace string surronding by backticks>`
```
e.g. 
```
espanso-regex:: ;username 
espanso-label:: my user name
espanso-filename:: personal
espanso-replace:: `bluckholl`
```
##### child code block replacement
```
espanso-regex:: <espanso trigger> 
espanso-label:: <espanso label, optional, to be displayed with espanso search bar>
espanso-filename:: <yaml filename (.yml ending is optional) , optional, default to logseq.yml>
```
- 
       ```
      <replace lines>
       ```

e.g. 
  ```
espanso-regex:: ;qblocked 
espanso-label:: blocked processes
espanso-filename:: queries.yml
```
- 
     ```sql
     SELECT *
     FROM sys.sysprocesses
     WHERE blocked <> 0
     ```
### Generating espanso yaml files
- `ctrl s` a must for saving logseq changes to transit db
- Running LogSeqToEspansoYaml.ps1 with your logseqGraph

      Bat file for easy run this convertor
       `"%PROGRAMFILES%\PowerShell\7\pwsh.exe" <Path>\LogseqEspansoIntegration\LogSeqToEspansoYaml.ps1 -logseqGraph "<Your Graph>"`     

### Installations    
- Install logseq-query https://github.com/cldwalker/logseq-query
  - copy repo queries.edn to `%APPDATA%\npm\node_modules\logseq-query\resources` (contains advance query to pull all espanso blocks)
- Install babashka https://github.com/babashka/babashka
- Install powershell-yaml `Install-Module -Name powershell-yaml -Force -Repository PSGallery -Scope CurrentUser`
- Bat file for easy run this convertor
`"%PROGRAMFILES%\PowerShell\7\pwsh.exe" <Path>\LogseqEspansoIntegration\LogSeqToEspansoYaml.ps1 -logseqGraph "<Your Graph>"`
