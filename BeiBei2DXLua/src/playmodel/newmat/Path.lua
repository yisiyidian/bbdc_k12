local Path = class("Path")

function Path:getPath(wordLength)
	if wordLength == 1 then
		return {cc.p(1,1)}
	elseif wordLength == 2 then
		return {cc.p(1,1),cc.p(1,2)}	
	elseif wordLength == 3 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3)}
	elseif wordLength == 4 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4)}
	elseif wordLength == 5 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5)}

	elseif wordLength == 6 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5)}
	elseif wordLength == 7 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4)}	
	elseif wordLength == 8 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3)}
	elseif wordLength == 9 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2)}
	elseif wordLength == 10 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1)}

	elseif wordLength == 11 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1)}
	elseif wordLength == 12 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2)}	
	elseif wordLength == 13 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3)}
	elseif wordLength == 14 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3.4)}
	elseif wordLength == 15 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5)}

	elseif wordLength == 15 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5)}
	elseif wordLength == 16 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4)}
	elseif wordLength == 17 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3)}	
	elseif wordLength == 18 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3),cc.p(4.2)}
	elseif wordLength == 19 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3),cc.p(4.2),cc.p(4,1)}

	elseif wordLength == 20 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3),cc.p(4.2),cc.p(4,1),
				cc.p(5,1)}
	elseif wordLength == 21 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3),cc.p(4.2),cc.p(4,1),
				cc.p(5,1),cc.p(5,2)}
	elseif wordLength == 22 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3),cc.p(4.2),cc.p(4,1),
				cc.p(5,1),cc.p(5,2),cc.p(5,3)}
	elseif wordLength == 23 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3),cc.p(4.2),cc.p(4,1),
				cc.p(5,1),cc.p(5,2),cc.p(5,3),cc.p(5,4)}		
	elseif wordLength == 24 then
		return {cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),
				cc.p(2,5),cc.p(2,4),cc.p(2,3),cc.p(2,2),cc.p(2,1),
				cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(2,5),
				cc.p(4,5),cc.p(4,4),cc.p(4,3),cc.p(4.2),cc.p(4,1),
				cc.p(5,1),cc.p(5,2),cc.p(5,3),cc.p(5,4),cc.p(5,5)}											
	end
end