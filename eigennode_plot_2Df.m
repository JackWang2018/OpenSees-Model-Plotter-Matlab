function [Nd,Coord,eDisp]=eigennode_plot_2Df(fname,fpath,nmds)
% Script to get eigenmodes of a 2D model
% Copyright by Gerard J. O'Reilly, 2017
% Written: Gerard J. O'Reilly
% Last Updated: Jan 2017

% close all; clear all; clc;
% [fname,fpath]=uigetfile('*.txt','Select eigennode file  ');
% nmds=6;

n=linecount(fullfile(fpath,fname));
fid=fopen(fullfile(fpath,fname),'r');
out=textscan(fid,'%s','delimiter','\n');
fclose(fid);

Nd=[];
Coord=[];
uDisp=cell(nmds,1);
eDisp=cell(nmds,1);
for i=1:nmds
    uDisp{i,1}=[];
end
for i=1:n-1
    a=strmatch('Node',out{1,1}(i,:)); % Look for Nodes
    if isempty(a)==0
        % Found an node so extract more info
%         fprintf('found Node at line: %d\n',i);
        temp1=textscan(out{1}{i},' Node: %d');
        Nd=[Nd; temp1{1}];
    end
    b=strmatch('Coordinates',out{1,1}(i,:)); % Look for Coordinates
    if isempty(b)==0  
        temp2=textscan(out{1}{i},'	Coordinates  : %f %f ');
        Coord=[Coord; [temp2{1}, temp2{2}]];
    end
    d=strmatch('Eigenvectors',out{1,1}(i,:)); % Look for eigenstuff
    if isempty(d)==0
%         fprintf('found Eigenvectors at line: %d\n',i);
        temp4=textscan(out{1}{i+1},'%f');
        temp5=textscan(out{1}{i+2},'%f');
        temp6=textscan(out{1}{i+3},'%f');
        tempp=[temp4{:}'; temp5{:}'; temp6{:}'];
        for ii=1:nmds
            uDisp{ii,1}=[uDisp{ii,1}; tempp(:,ii)'];
        end
    end

end

for i=1:nmds
    q1=max(max(uDisp{i,1}));
    q2=min(min(uDisp{i,1}));
    if q1>=abs(q2)
        eDisp{i,1}=uDisp{i,1}/q1;
    elseif abs(q2)>q1
        eDisp{i,1}=uDisp{i,1}/q2;
    end
end

