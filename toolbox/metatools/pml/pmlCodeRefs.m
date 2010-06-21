function [codename, pg, datestr] = pmlCodeRefs(codeIndFile)
% Return a list of all of the code files referenced in PML 
% along with the (hard cover) pages on which they are first referenced.
%
%% Input
% codeIndFile - path to the code.ind file generated by the
% latex "makeindex code" command.
% (default = 'C:\kmurphy\dropbox\PML\Text\code.ind')
%
%% Output
% codename - name of the file
% pg       - a cell array, each entry stores a list of the pages
% datestr  - a date string indicating the last time the codeIndFile was
%            modified. 
if nargin ==0
    codeIndFile =  getConfigValue('PMTKpmlCodeIndFile'); 
end
datestr = getFileModificationDate(codeIndFile); 
if ~exist(codeIndFile, 'file')
    error('Could not find %s. Check the path and try recompiling the latex source and/or regenerating the index with "makeindex code".', codeIndFile);
end

text = getText(codeIndFile);
text = filterCell(text, @(s)startswith(strtrim(s), '\item'));
text = cellfuncell(@(c)c(9:end), text);
nrefs = numel(text);
codename = cell(nrefs, 1);
pg = cell(nrefs, 1);
for i=1:nrefs
    toks = tokenize(text{i}, ' ,');
    toks = filterCell(toks, @(c)~isempty(c)); 
    codename{i} = toks{1};
    pg{i} = cellfun(@str2num, toks(2:end))';
end


end