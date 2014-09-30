

function mat(m, n)
    -- local variate
    local main_mat
    local main_m
    local main_n
    local isFindPath
    local dir
    
    -- local function
    local init
    local printMat
    local randomPoint
    local disoriginizeDirction
    local randomPath
    
    -- function detail
    init = function()
        main_m = m
        main_n = n
        isFindPath = false
        dir = {1,2,3,4}
        
        main_mat = {}
        for i = 1, main_m do
            main_mat[i] = {}
            for j = 1, main_n do
                main_mat[i][j] = 0
            end
        end

        randomPath(0,0,0)
        printMat()
    end

    printMat = function()
        for i = 1, main_m do
            tmp = ""
            for j = 1, main_n do
                tmp = tmp .. main_mat[i][j] .." "
            end
            print(tmp)
        end
    end

    randomPoint = function()
        if (main_m%2 == 1 and main_n%2 == 1) then
            while 1 do
                math.randomseed(os.time())
                randomX = math.random(1, main_m)
                randomY = math.random(1, main_n)
                if ((randomX + randomY)%2 == 0) then
                    return {x=randomX, y=randomY}
                end            
            end
        end
        math.randomseed(os.time())
        return {x=math.random(1, main_m), y=math.random(1, main_n)}
    end

    disoriginizeDirction = function()
        for i =1, 4 do
            math.randomseed(os.time())
            randomIndex = math.random(1,4)
            tmp = dir[i]
            dir[i] = dir[randomIndex]
            dir[randomIndex] = tmp
        end
    end

    randomPath = function(currentIndex, currentX, currentY)
        if isFindPath then
            return
        end
    
        if currentIndex == 0 then
            local randomPoint = randomPoint()
            randomPath(currentIndex+1, randomPoint.x, randomPoint.y)
            return
        end
    
        main_mat[currentX][currentY] = currentIndex
    
        if (currentIndex == main_m * main_n) then
            isFindPath = true
            return
        end
    
        disoriginizeDirction()
        
        for d = 1, #dir do
            if dir[d] == 1 and currentY+1 <= main_n and main_mat[currentX][currentY+1] == 0 then
                randomPath(currentIndex+1,currentX,currentY+1)
            elseif dir[d] ==2 and currentY-1 >= 1 and main_mat[currentX][currentY-1] == 0 then
                randomPath(currentIndex+1,currentX,currentY-1)
            elseif dir[d] == 3 and currentX+1 <= main_m and main_mat[currentX+1][currentY] == 0 then
                randomPath(currentIndex+1,currentX+1,currentY)
            elseif dir[d] == 4 and currentX-1 >= 1 and main_mat[currentX-1][currentY] == 0 then
                randomPath(currentIndex+1,currentX-1,currentY)
            end
        end
        
        if not isFindPath then
            main_mat[currentX][currentY] = 0
        end
    end

    init()
end