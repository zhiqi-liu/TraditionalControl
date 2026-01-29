% created by lzq
function saveimg(n,filename,format)

if nargin == 1
    filename = num2str(n);
    format = "png";
elseif nargin == 2
    format = "png";
end

cur_root = pwd;
file_name = fullfile(cur_root,strcat(filename,'.',format));
saveas(n,file_name)
disp("save the figure of "+filename+" to the floder image.")