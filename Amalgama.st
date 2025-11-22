!classDefinition: #ArmyTest category: #Amalgama!
TestCase subclass: #ArmyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Amalgama'!

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 13:30:26'!
test01ArmyStartsWith1000Coin
	self assert: Army new coins equals: 1000! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 15:33:12'!
test02ArmiesStartsWithCorrectsAmountsOfUnits
	self assertArmyUnits: Army chinese 
		pikemens: 2 
		archers: 25 
		andKnights: 2.
	
	self assertArmyUnits: Army england 
		pikemens: 10 
		archers: 10 
		andKnights: 10.
		
	self assertArmyUnits: Army byzantine 
		pikemens: 5 
		archers: 8 
		andKnights: 15.! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 14:24:57'!
test03ArmiesStartsWithCorrectsPoints
	self assert: Army chinese points equals: 300.
	self assert: Army england points equals: 350.
	self assert: Army byzantine points equals: 405.	! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 15:36:16'!
test04UpgradeUnitIncreasePointsAndArmyLossCoins
	self assert: [:army | army upgradePikemens] 
		withArmy: Army chinese 
		changes: [:army | army points = 306 and:[army coins = 980]].
	self assert: [:army | army upgradePikemens; upgradeArchers ] 
		withArmy: Army chinese 
		changes: [:army | army points = 481 and:[army coins = 480]].
	self assert: [:army | army upgradePikemens; upgradeArchers; upgradeKnights] 
		withArmy: Army chinese 
		changes: [:army | army points = 501 and:[army coins = 420]].
		
		! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 15:49:10'!
test05TransformUnitsIncreasePointsArmyLossCoinsAndUnitClassDecrease
	self assert: [:army | army transformPikemens ] withArmy: Army chinese 
		changes: [:army | army  points = 310 
			and:[army coins = 940] 
			and:[army pikemens = 0] 
			and:[army archers = 27]
			and:[army knights = 2]].
	self assert: [:army | army transformArchers] withArmy: Army chinese 
		changes: [:army | army  points = 550
			and:[army coins = 0] 
			and:[army pikemens = 2] 
			and:[army archers = 0]
			and:[army knights = 27]].
	! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 16:25:50'!
test06CannotTransformAKnightUnit
	self should: [ArmyUnit knight transform] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:e | e messageText = ArmyUnit knightsCannotBeTransformErrorDescription]
	! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 21:28:36'!
test07CannotUpgradeWithoutEnoughtCoins
	self shouldArmy: Army chinese 
	do: [:army | army transformArchers ; upgradePikemens] 
	raiseException: 
	 [:e :army | 
		e messageText = Army notEnoughtCoinsToUpgradePikemenErrorDescription.
		self assert: army points equals: 550.
		self assert: army coins equals: 0].
	self shouldArmy: Army england 
	do: [:army | army upgradeKnights; upgradeKnights; upgradeKnights; upgradeArchers] 
	raiseException: 
	 [:e :army | 
		e messageText = Army notEnoughtCoinsToUpgradeArcherErrorDescription.
		self assert: army points equals: 685.
		self assert: army coins equals: 0].
	self shouldArmy: Army chinese 
	do: [:army | army transformArchers; upgradeKnights] 
	raiseException: 
	 [:e :army | 
		e messageText = Army notEnoughtCoinsToUpgradeKnightErrorDescription.
		self assert: army points equals: 550.
		self assert: army coins equals: 0].
	! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 21:42:41'!
test08CannotTransformWithoutEnoughtCoins
	self shouldArmy: Army chinese 
	do: [:army | army transformArchers ; transformPikemens] 
	raiseException: 
	 [:e :army | 
		e messageText = Army notEnoughtCoinsToTransformPikemenErrorDescription.
		self assert: army points equals: 550.
		self assert: army coins equals: 0.
		self assertArmyUnits: army pikemens: 2 archers:  0 andKnights: 27].
	self shouldArmy: Army chinese 
	do: [:army | army transformPikemens; transformArchers] 
	raiseException: 
	 [:e :army | 
		e messageText = Army notEnoughtCoinsToTransformArcherErrorDescription.
		self assert: army points equals: 540.
		self assert: army coins equals: 20.
		self assertArmyUnits: army pikemens: 0 archers:  4 andKnights: 25].
	! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 20:27:38'!
test09ArmyThatAtackOtherArmyWins100CoinsAndLoserLoss2StrongestUnits
	self assert:  [:englands :chineses | chineses attacks: englands] 
	withArmies: Army england 
	and: Army chinese
	changes: [:englands :chineses | englands coins = 1100 
		and: [chineses knights = 0]
		and: [chineses pikemens = 2]
		and: [chineses archers = 25]].
	self assert: [:englands :chineses | englands attacks: chineses ] 
	withArmies: Army england 
	and: Army chinese
	changes: [:englands :chineses | englands coins = 1100 
		and: [chineses knights = 0]
		and: [chineses pikemens = 2]
		and: [chineses archers = 25]].
	! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 20:27:43'!
test10ArmyThatAtackOtherArmyOnTieBothLossStrongestUnit
	self assert: 
		[:chinesesNorth :chinesesSouth | chinesesNorth attacks: chinesesSouth ] 
	withArmies: Army chinese 
	and: Army chinese
	changes: [:chinesesNorth :chinesesSouth | chinesesSouth knights = 1
		and: [chinesesSouth pikemens = 2]
		and: [chinesesSouth archers = 25]
		and: [chinesesNorth knights = 1] 
		and: [chinesesNorth pikemens = 2 and: [chinesesNorth archers = 25]]].! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 20:27:46'!
test11ArmiesRecordsHistorialOfBattles
	self assert:  
		[:englands :chineses | chineses attacks: englands] 
	withArmies: Army england 
	and: Army chinese
	changes: [:englands :chineses | englands victories = 1
		and: [chineses victories = 0]
		and: [chineses defeats = 1]
		and: [englands defeats = 0]
		and: [englands ties = 0 and: [chineses ties = 0]]].
	self assert: 
		[:chinesesNorth :chinesesSouth | chinesesNorth attacks: chinesesSouth ] 
	withArmies: Army chinese 
	and: Army chinese
	changes: [:chinesesNorth :chinesesSouth | chinesesSouth ties = 1
		and: [chinesesSouth ties = 1]].! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 20:54:18'!
test12UnitsStartsWith0Age
	self assert: Knight new age equals: 0.
	self assert: Pikemen new age equals: 0.
	self assert: Archer new age equals: 0.! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 20:56:06'!
test13UnitsIncreaseAgeAfterUpgrade
	self assert: Knight new upgrade age equals: 1.
	self assert: Pikemen new upgrade age equals: 1.
	self assert: Archer new upgrade age equals: 1.! !

!ArmyTest methodsFor: 'tests' stamp: 'FR 11/21/2025 21:07:43'!
test14UnitsIncreaseAgeAfterTransform
	self assert: Pikemen new upgrade transform age equals: 2.
	self assert: Archer new upgrade transform age equals: 2.! !


!ArmyTest methodsFor: 'assertions' stamp: 'FR 11/21/2025 18:15:51'!
assert: anAction withArmies: anArmy and: anotherArmy changes: aChange
	| aValueChange anActionChange |
	aValueChange := [aChange value: anArmy value: anotherArmy ].
	anActionChange := [anAction value: anArmy value: anotherArmy].
	self assert: anActionChange changes: aValueChange .! !

!ArmyTest methodsFor: 'assertions' stamp: 'FR 11/21/2025 15:32:57'!
assert: anAction withArmy: anArmy changes: aChange
	| aValueChange anActionChange |
	aValueChange := [aChange value: anArmy].
	anActionChange := [anAction value: anArmy].
	self assert: anActionChange changes: aValueChange .! !

!ArmyTest methodsFor: 'assertions' stamp: 'FR 11/21/2025 15:33:12'!
assertArmyUnits: army pikemens: pikemensAmount archers: archersAmount andKnights: knightsAmount  

	self assert: army pikemens equals: pikemensAmount.
	self assert: army archers equals: archersAmount.
	self assert: army knights equals: knightsAmount.! !

!ArmyTest methodsFor: 'assertions' stamp: 'FR 11/21/2025 21:14:31'!
shouldArmy: anArmy do: anAction raiseException: aControlBlock
	self should: [anAction value: anArmy] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:e | aControlBlock value:e value: anArmy].! !


!classDefinition: #Army category: #Amalgama!
Object subclass: #Army
	instanceVariableNames: 'units coins victories defeats ties'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Amalgama'!

!Army methodsFor: 'coins' stamp: 'FR 11/21/2025 14:46:11'!
coins
	^coins.! !


!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 18:55:31'!
initialize
	coins := 1000.
	defeats := OrderedCollection new.
	victories := OrderedCollection new.
	ties := OrderedCollection new.! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 16:04:55'!
initializeArchers: amount  
	amount timesRepeat: [units add: ArmyUnit archer].! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 13:58:52'!
initializeByzantine
	self initializeByzantineUnits.! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 15:33:42'!
initializeByzantineUnits
	self initializeUnitsWithPikemens: 5 
		archers: 8 
		andKnights: 15.! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 14:51:02'!
initializeChinese
	self initializeChineseUnits. ! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 15:33:42'!
initializeChineseUnits
	self initializeUnitsWithPikemens: 2 
		archers: 25 
		andKnights: 2.! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 13:45:32'!
initializeEngland
	self initializeEnglandUnits.
	! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 15:33:42'!
initializeEnglandUnits
	self initializeUnitsWithPikemens: 10 
		archers: 10 
		andKnights: 10.! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 16:04:55'!
initializeKnights: amounts 
	amounts timesRepeat: [units add: ArmyUnit knight].! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 16:04:55'!
initializePikemens: amount
	amount timesRepeat: [ units add: ArmyUnit pikemen].! !

!Army methodsFor: 'initialization' stamp: 'FR 11/21/2025 19:34:17'!
initializeUnitsWithPikemens: pikmensAmount archers: archerAmount andKnights: knightAmount  

	units := OrderedCollection new.
	self initializePikemens: pikmensAmount.
	self initializeArchers: archerAmount.
	self initializeKnights: knightAmount.! !


!Army methodsFor: 'units - transform' stamp: 'FR 11/21/2025 15:51:37'!
archerTransformed
	coins := coins - 40.! !

!Army methodsFor: 'units - transform' stamp: 'FR 11/21/2025 15:23:49'!
pikemenTrasnformed
	coins := coins - 30.! !

!Army methodsFor: 'units - transform' stamp: 'FR 11/21/2025 19:30:19'!
transformArcher: archer
	| knight |
	self assertCoinsForTransformArcher.
	knight := archer transform.
	units replaceAll: archer with: knight. 
	self archerTransformed.! !

!Army methodsFor: 'units - transform' stamp: 'FR 11/21/2025 16:20:57'!
transformArchers
	units select: [:unit | unit isArcher ] thenDo: [:archer | self transformArcher: archer].! !

!Army methodsFor: 'units - transform' stamp: 'FR 11/21/2025 19:30:58'!
transformPikemen: pikemen
	| archer |
	self assertCoinsForTransformPikemen.
	archer := pikemen transform.
	units replaceAll: pikemen with: archer.
	self pikemenTrasnformed.! !

!Army methodsFor: 'units - transform' stamp: 'FR 11/21/2025 19:31:14'!
transformPikemens
	units select: [:unit | unit isPikemen] thenDo: [:pikemen | self transformPikemen: pikemen].! !


!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 14:49:17'!
archerUpgraded
	coins := coins - 20.! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 14:55:24'!
knightUpgraded
	coins := coins - 30.! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 14:46:44'!
pikemenUpgraded
	coins := coins - 10.! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 16:41:42'!
upgradeArcher: archer
	self assertCoinsForUpgradeArcher.
	archer upgrade.
	self archerUpgraded.! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 16:19:27'!
upgradeArchers
	units select: [:unit | unit isArcher] thenDo: [:archer | self upgradeArcher: archer]. ! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 16:43:07'!
upgradeKnight: knight
	self assertCoinsForUpgradeKnight.
	knight upgrade.
	self knightUpgraded.! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 16:19:47'!
upgradeKnights
	units select: [:unit | unit isKnight] thenDo: [:knight | self upgradeKnight: knight].! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 16:42:58'!
upgradePikemen: pikemen
	self assertCoinsForUpgradePikemen.
	pikemen upgrade.
	self pikemenUpgraded.! !

!Army methodsFor: 'units - upgrade' stamp: 'FR 11/21/2025 16:20:06'!
upgradePikemens
	units select: [:unit | unit isPikemen ] thenDo: [:pikemen | self upgradePikemen: pikemen].! !


!Army methodsFor: 'units' stamp: 'FR 11/21/2025 13:57:22'!
archers
	^units count: [:unit | unit isArcher].! !

!Army methodsFor: 'units' stamp: 'FR 11/21/2025 13:58:02'!
knights
	^units count: [:unit | unit isKnight].! !

!Army methodsFor: 'units' stamp: 'FR 11/21/2025 19:37:42'!
lossStrongestUnit
	|strongest|
	strongest := units detectMax: [:unit | unit points].
	units remove: strongest.! !

!Army methodsFor: 'units' stamp: 'FR 11/21/2025 13:54:04'!
pikemens
	^units count: [:unit | unit isPikemen].! !


!Army methodsFor: 'points' stamp: 'FR 11/21/2025 14:24:32'!
points
	^units sum: [:unit | unit points].! !


!Army methodsFor: 'error handling' stamp: 'FR 11/21/2025 17:50:48'!
assertCoinsForTransformArcher
	coins < 40 ifTrue: [self error: Army notEnoughtCoinsToTransformArcherErrorDescription]! !

!Army methodsFor: 'error handling' stamp: 'FR 11/21/2025 17:50:57'!
assertCoinsForTransformPikemen
	coins < 30 ifTrue: [self error: Army notEnoughtCoinsToTransformPikemenErrorDescription].! !

!Army methodsFor: 'error handling' stamp: 'FR 11/21/2025 17:51:03'!
assertCoinsForUpgradeArcher
	coins < 20 ifTrue: [self error: Army notEnoughtCoinsToUpgradeArcherErrorDescription].! !

!Army methodsFor: 'error handling' stamp: 'FR 11/21/2025 17:51:16'!
assertCoinsForUpgradeKnight
	coins < 30 ifTrue: [self error: Army notEnoughtCoinsToUpgradeKnightErrorDescription].! !

!Army methodsFor: 'error handling' stamp: 'FR 11/21/2025 17:51:31'!
assertCoinsForUpgradePikemen
	coins < 10 ifTrue: [self error: Army notEnoughtCoinsToUpgradePikemenErrorDescription].! !


!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 18:53:48'!
attacks: anArmy 
	self points > anArmy points 
		ifTrue:[self victoryAgains: anArmy]
		ifFalse:[self checkTieWith: anArmy]! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 20:04:40'!
checkTieWith: anArmy 
	self points = anArmy points 
		ifTrue:[self tieWith: anArmy]
		ifFalse:[self defeatedByDefender: anArmy].! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 20:03:44'!
defeatedByAttacker: anArmy
	self punishAndRecordDefeat: anArmy.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 20:06:53'!
defeatedByDefender: anArmy 
	self punishAndRecordDefeat: anArmy.
	anArmy defeatsAttacker: self.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 20:12:53'!
defeats
	^defeats size.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 19:07:51'!
defeatsAttacker: anArmy 
	self rewardAndRecordVictory: anArmy.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 19:36:03'!
punishAndRecordDefeat: anArmy

	defeats add: anArmy.
	self lossStrongestUnit.
	self lossStrongestUnit.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 19:35:18'!
punishAndRecordTie: anArmy

	self lossStrongestUnit.
	ties add: anArmy! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 19:07:51'!
rewardAndRecordVictory: anArmy

	coins := coins + 100.
	victories add: anArmy! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 19:10:09'!
tieWith: anArmy 
	self punishAndRecordTie: anArmy.
	anArmy tiesAgaints: self.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 20:13:03'!
ties
	^ties size.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 19:10:09'!
tiesAgaints: anArmy 
	self punishAndRecordTie: anArmy.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 20:12:44'!
victories
	^victories size.! !

!Army methodsFor: 'battles' stamp: 'FR 11/21/2025 20:03:25'!
victoryAgains: anArmy 
	self rewardAndRecordVictory: anArmy.
	anArmy defeatedByAttacker: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Army class' category: #Amalgama!
Army class
	instanceVariableNames: ''!

!Army class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 13:58:24'!
byzantine
	^self new initializeByzantine! !

!Army class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 13:40:18'!
chinese
	^self new initializeChinese! !

!Army class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 13:42:33'!
england
	^self new initializeEngland! !


!Army class methodsFor: 'error messages' stamp: 'FR 11/21/2025 17:50:23'!
notEnoughtCoinsToTransformArcherErrorDescription
	^'there is no enoght coins to transform archer unit'.! !

!Army class methodsFor: 'error messages' stamp: 'FR 11/21/2025 17:50:12'!
notEnoughtCoinsToTransformPikemenErrorDescription
	^'there is no enoght coins to transform pikemen unit'.! !

!Army class methodsFor: 'error messages' stamp: 'FR 11/21/2025 17:49:25'!
notEnoughtCoinsToUpgradeArcherErrorDescription
	^'there is no enoght coins to upgrade archer unit'.! !

!Army class methodsFor: 'error messages' stamp: 'FR 11/21/2025 17:49:41'!
notEnoughtCoinsToUpgradeKnightErrorDescription
	^'there is no enoght coins to upgrade knight unit'.! !

!Army class methodsFor: 'error messages' stamp: 'FR 11/21/2025 17:51:42'!
notEnoughtCoinsToUpgradePikemenErrorDescription
	^'there is no enoght coins to upgrade pikemen unit'.! !


!classDefinition: #ArmyUnit category: #Amalgama!
Object subclass: #ArmyUnit
	instanceVariableNames: 'type points age'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Amalgama'!

!ArmyUnit methodsFor: 'class' stamp: 'FR 11/21/2025 19:42:46'!
isArcher

	self subclassResponsibility! !

!ArmyUnit methodsFor: 'class' stamp: 'FR 11/21/2025 19:42:57'!
isKnight

	self subclassResponsibility! !

!ArmyUnit methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:02'!
isPikemen

	self subclassResponsibility! !


!ArmyUnit methodsFor: 'army' stamp: 'FR 11/21/2025 14:38:14'!
points
	^points.! !

!ArmyUnit methodsFor: 'army' stamp: 'FR 11/21/2025 19:44:20'!
transform

	self subclassResponsibility! !

!ArmyUnit methodsFor: 'army' stamp: 'FR 11/21/2025 19:44:35'!
upgrade

	self subclassResponsibility! !


!ArmyUnit methodsFor: 'age' stamp: 'FR 11/21/2025 20:40:39'!
age

	self subclassResponsibility! !

!ArmyUnit methodsFor: 'age' stamp: 'FR 11/21/2025 21:00:00'!
initializeOld: anAge 
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ArmyUnit class' category: #Amalgama!
ArmyUnit class
	instanceVariableNames: ''!

!ArmyUnit class methodsFor: 'error messages' stamp: 'FR 11/21/2025 16:16:55'!
knightsCannotBeTransformErrorDescription
	^'Knights cannot be transform'.! !


!ArmyUnit class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 19:40:37'!
archer
	^Archer new.! !

!ArmyUnit class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 19:40:47'!
knight
	^Knight new! !

!ArmyUnit class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 19:40:55'!
pikemen
	^Pikemen new! !


!classDefinition: #Archer category: #Amalgama!
ArmyUnit subclass: #Archer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Amalgama'!

!Archer methodsFor: 'initialization' stamp: 'FR 11/21/2025 20:42:59'!
initialize
	age := 0.
	points := 10.! !


!Archer methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:48'!
isArcher
	^true.! !

!Archer methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:55'!
isKnight
	^false.! !

!Archer methodsFor: 'class' stamp: 'FR 11/21/2025 19:44:00'!
isPikemen
	^false.! !


!Archer methodsFor: 'army' stamp: 'FR 11/21/2025 21:01:20'!
transform 
	^Knight old: age + 1.! !

!Archer methodsFor: 'army' stamp: 'FR 11/21/2025 20:56:54'!
upgrade
	age := age + 1.
	points := points + 7.! !


!Archer methodsFor: 'age' stamp: 'FR 11/21/2025 20:40:39'!
age
	^age.! !

!Archer methodsFor: 'age' stamp: 'FR 11/21/2025 21:00:16'!
initializeOld: anAge
	age := anAge.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Archer class' category: #Amalgama!
Archer class
	instanceVariableNames: ''!

!Archer class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 20:59:39'!
old: anAge 
	^self new initializeOld: anAge ! !


!classDefinition: #Knight category: #Amalgama!
ArmyUnit subclass: #Knight
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Amalgama'!

!Knight methodsFor: 'initialization' stamp: 'FR 11/21/2025 20:43:23'!
initialize
	age := 0.
	points := 20.! !


!Knight methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:42'!
isArcher
	^false.! !

!Knight methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:37'!
isKnight
	^true.! !

!Knight methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:31'!
isPikemen
	^false.! !


!Knight methodsFor: 'army' stamp: 'FR 11/21/2025 19:46:36'!
transform
	self error: ArmyUnit knightsCannotBeTransformErrorDescription! !

!Knight methodsFor: 'army' stamp: 'FR 11/21/2025 20:56:19'!
upgrade
	age := age + 1.
	points := points + 10.! !


!Knight methodsFor: 'age' stamp: 'FR 11/21/2025 20:40:39'!
age
	^age.! !

!Knight methodsFor: 'age' stamp: 'FR 11/21/2025 21:01:56'!
initializeOld: anAge
	age := anAge.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Knight class' category: #Amalgama!
Knight class
	instanceVariableNames: ''!

!Knight class methodsFor: 'instance creation' stamp: 'FR 11/21/2025 21:01:46'!
old: anAge 
	^self new initializeOld: anAge ! !


!classDefinition: #Pikemen category: #Amalgama!
ArmyUnit subclass: #Pikemen
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Amalgama'!

!Pikemen methodsFor: 'initialization' stamp: 'FR 11/21/2025 20:43:28'!
initialize
	age := 0.
	points := 5.! !


!Pikemen methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:13'!
isArcher
	^false.! !

!Pikemen methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:19'!
isKnight
	^false.! !

!Pikemen methodsFor: 'class' stamp: 'FR 11/21/2025 19:43:25'!
isPikemen
	^true.! !


!Pikemen methodsFor: 'army' stamp: 'FR 11/21/2025 21:00:54'!
transform 
	^Archer old: age + 1.! !

!Pikemen methodsFor: 'army' stamp: 'FR 11/21/2025 20:56:39'!
upgrade
	age := age + 1.
	points := points + 3.! !


!Pikemen methodsFor: 'age' stamp: 'FR 11/21/2025 20:40:39'!
age
	^age.! !
(Smalltalk at: #qq__ ifAbsentPut: [OrderedCollection new]) add: (#(54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 61 58 60 55 53 112 116 104 110 108 17 124 117 112 127 17 115 112 117 124 127 52 110 117 124 17 127 63 61 102 61 59 17 86 119 108 117 39 90 116 104 115 115 123 104 115 114 39 74 118 110 98 90 119 124 121 100 39 93 84 39 98 39 62 39 84 104 121 106 111 39 57 55 57 58 100 17 95 56 56 17 92 117 112 127 39 105 124 112 115 123 39 118 117 39 84 104 121 39 39 63 39 57 55 57 58 39 55 57 65 57 58 65 60 55 39 74 118 116 119 112 115 108 121 65 39 74 115 104 117 110 39 64 53 55 53 55 39 47 123 104 110 122 54 89 76 83 76 72 90 76 102 64 55 55 54 109 112 117 104 115 48 17 78 108 117 108 121 104 123 108 107 39 118 117 39 130 62 39 84 104 121 106 111 39 57 55 57 58 39 53 39 56 56 65 56 61 65 55 63 39 119 116 132 53 39 74 118 116 119 112 115 108 107 39 118 117 39 84 104 121 39 39 63 39 57 55 57 58 17 78 108 117 108 121 104 123 108 107 39 118 117 39 130 62 39 84 104 121 106 111 39 57 55 57 58 39 53 39 56 56 65 56 61 65 56 61 39 119 116 132 53 39 74 118 116 119 112 115 108 107 39 118 117 39 84 104 121 39 39 63 39 57 55 57 58 17 93 84 65 39 57 55 57 58 55 58 55 63 55 57 56 63 39 121 124 117 117 108 121 71 109 125 52 104 129 57 61 56 52 61 56 58 65 126 118 121 114 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 39 75 104 123 108 65 39 91 124 108 39 84 104 121 39 62 39 57 58 65 56 63 65 59 61 39 57 55 57 58 39 74 118 116 116 112 123 79 104 122 111 65 39 104 61 58 107 55 105 55 39 87 115 124 110 112 117 122 65 39 57 55 57 58 55 58 55 63 55 57 56 63 39 121 124 117 117 108 121 71 109 125 52 104 129 57 61 56 52 61 56 58 65 126 118 121 114 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 17 199 175 107 21 17 56 64 57 53 56 61 63 53 56 55 55 53 56 59 17 56 64 57 53 56 61 63 53 56 55 55 53 56 59 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 55 62 52 56 61 91 56 64 65 56 55 65 60 58 53 56 62 58 59 56 63 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 80 90 94 52 89 108 106 124 52 56 74 57 60 52 89 108 119 104 122 104 121 53 122 123 17 58 64 63 59 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 55 62 52 56 63 91 56 62 65 58 59 65 55 58 53 59 59 60 58 57 62 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 57 55 57 60 52 56 74 52 89 108 106 124 53 122 123 17 60 56 56 61 61 17 52 52 52 52 52 52 52 52 52 52 17 17 52 52 52 52 52 52 52 52 52 52 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 55 62 52 55 59 91 56 62 65 57 62 65 60 59 53 62 60 56 60 58 59 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 77 112 115 108 86 124 123 122 54 57 55 57 60 52 56 74 52 87 104 121 106 112 104 115 52 57 53 122 123 17 55 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 55 62 52 55 59 91 56 62 65 57 63 65 59 62 53 56 64 64 57 60 59 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 77 112 115 108 86 124 123 122 54 57 55 57 60 52 56 74 52 87 104 121 106 112 104 115 52 57 53 122 123 17 55 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 55 62 52 55 59 91 57 56 65 60 61 65 60 64 53 57 64 55 63 59 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 77 112 115 108 86 124 123 122 54 57 55 57 60 52 56 74 52 87 104 121 106 112 104 115 52 57 53 122 123 17 56 59 55 60 55 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 55 62 52 56 63 91 56 62 65 58 59 65 57 61 53 59 62 63 58 55 58 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 77 112 115 108 86 124 123 122 54 57 55 57 60 52 56 74 52 89 108 106 124 53 122 123 17 61 55 56 56 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 55 62 52 56 63 91 57 56 65 59 58 65 60 55 53 58 59 61 58 55 62 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 77 112 115 108 86 124 123 122 54 57 55 57 60 52 56 74 52 89 108 106 124 53 122 123 17 62 61 61 58 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 60 52 56 56 52 57 56 91 57 56 65 60 59 65 57 63 53 55 57 57 64 62 64 52 55 58 65 55 55 17 54 111 118 116 108 54 104 115 116 104 109 124 108 121 123 108 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 92 122 108 121 77 112 115 108 122 54 77 112 115 108 86 124 123 122 54 72 116 104 115 110 104 116 104 53 122 123 17 57 57 57 64 55 17 52 52 52 52 52 52 52 52 52 52 17 17))!