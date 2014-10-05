require "model.ReadAllWord"

local StudyLayer = require("view.StudyLayer")

local CorePlayManager = class("CorePlayManager", function()
    return cc.Layer:create()
end)

function CorePlayManager.create()
    local main = CorePlayManager.new()
   
    main.loadConfiguation = function()
    	
	end

    main.enterStudyLayer = function()
    	local studyLayer = StudyLayer.create()
		main:addChild(studyLayer)
	end

	main.leaveStudyLayer = function()
    	
	end

	main.enterTestLayer = function()
    	
	end

	main.leaveTestLayer = function()
    	
	end

	return main
end


return CorePlayManager
