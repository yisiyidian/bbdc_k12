-- 引导label数据 配置文件
-- by 侯琪
-- 2015年06月05日11:47:47
--{["guide_id"] = 引导的步骤
-- pos=label出现的位置	
-- desc=label显示的文字}, 			

local GuideConfig = {}

GuideConfig.data = {
	{["guide_id"] = 1,	pos=cc.p(s_DESIGN_WIDTH *0.5,1050)	,desc="请选择合适你的年级"					,color="white"			}, 			
	{["guide_id"] = 2,	pos=cc.p(s_DESIGN_WIDTH *0.6,1050)	,desc="请选择合适你的书籍"					,color="white"			}, 	
	{["guide_id"] = 3,	pos=cc.p(s_DESIGN_WIDTH / 2,200)	,desc="点击上方按钮进入游戏"				,color="yellow"			},
	{["guide_id"] = 4,	pos=cc.p(s_DESIGN_WIDTH / 2,1000)	,desc="boss过来啦，快划词"				,color="yellow"			},
	{["guide_id"] = 5,	pos=cc.p(s_DESIGN_WIDTH / 2,600)	,desc="是时候来一场真正的战斗了"			,color="yellow"			,bb="bb"},
	{["guide_id"] = 6,	pos=cc.p(s_DESIGN_WIDTH *0.6,650)	,desc=""								,color="blue1"			},
	{["guide_id"] = 7,	pos=cc.p(s_DESIGN_WIDTH / 2,400)	,desc="是不是很简单？走起"		,color="white"			},
	{["guide_id"] = 8,	pos=cc.p(s_DESIGN_WIDTH *0.6,650)	,desc=""								,color="blue2"			},
	{["guide_id"] = 9,	pos=cc.p(s_DESIGN_WIDTH / 2,1000)	,desc="把牌子上面中文对应出来的英文划出来"	,color="yellow"			},
	{["guide_id"] = 10,	pos=cc.p(s_DESIGN_WIDTH / 2,1000)	,desc="boss抓到贝贝就完蛋了"				,color="yellow"			},
	{["guide_id"] = 11,	pos=cc.p(s_DESIGN_WIDTH / 2,1000)	,desc="快划出这个词"						,color="yellow"			},
	{["guide_id"] = 12,	pos=cc.p(s_DESIGN_WIDTH / 2,1000)	,desc="不会的话果断求提示，不丢人"			,color="yellow"			},
	{["guide_id"] = 13,	pos=cc.p(s_DESIGN_WIDTH / 2,600)	,desc="打败boss竟然掉落一个宝箱"			,color="yellow"			,bb="bb3"},
	{["guide_id"] = 14,	pos=cc.p(s_DESIGN_WIDTH / 2,200)	,desc="打开宝箱就掉出\n一张纸，坑爹"		,color="sp1"},
	{["guide_id"] = 15,	pos=cc.p(s_DESIGN_WIDTH / 2,200)	,desc="这不就是我刚才\n做的事情吗"         	,color="sp2"},
	{["guide_id"] = 16,	pos=cc.p(s_DESIGN_WIDTH / 2,800)	,desc="说好的超级多的钱呢"			,color="yellow"			,bb="bb4"},
	{["guide_id"] = 17,	pos=cc.p(s_DESIGN_WIDTH / 2,800)	,desc="这么拼，才给我10个豆子？"			,color="yellow"			,bb="bb5"},
	{["guide_id"] = 18,	pos=cc.p(s_DESIGN_WIDTH / 2,800)	,desc="太好了，我最喜欢新挑战了！"		,color="yellow"			,bb="bb6"},
}

return GuideConfig