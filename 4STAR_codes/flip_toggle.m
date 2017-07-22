function toggle = flip_toggle(toggle)
% toggle = flip_toggle(toggle)
toggle_ = toggle;
togs = fieldnames(toggle);
for t = length(togs):-1:1
   if toggle.(togs{t})==0
      toggle.(togs{t}) = false;
   elseif toggle.(togs{t})==1
      toggle.(togs{t}) = true;
   end
   if ~islogical(toggle.(togs{t}))
      togs(t)= [];
   end
end
ntogs = length(togs);
done = false;
while ~done

for t = length(togs):-1:1
   TF = 'false';
   if toggle.(togs{t})
      TF = 'true';
   end
   tog_str(t) = {[togs{t}, ': <',TF,'>']};
end
tog_str(ntogs+1) = {''}; tog_str(ntogs+2) = {'DONE'};tog_str(ntogs+3) = {'ABORT'};
mn = menu({'Select a toggle to flip state, "DONE" when finished, ';'"ABORT" to revert to original and quit'}, tog_str);
if mn<=length(togs)
   toggle.(togs{mn}) = ~(toggle.(togs{mn}));
elseif mn == ntogs+2
      done = true;
elseif mn == ntogs+3
   toggle = toggle_; 
   done = true;
end
end

return
