function DisplayMessageAndWaitForButtonPress(textInput)

global DisplayTagGlobal;
global DisplayTag;

if DisplayTag && DisplayTagGlobal
    title(['\fontsize{16}' textInput])
    waitforbuttonpress
end



end