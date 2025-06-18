B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
'#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	Private XUI 			As XUI
	Private Root 			As B4XView
	Private mBase 			As B4XView
	Private Drawer 			As B4XDrawer
	Private Timer1 			As Timer
	Private LblTitle 		As Label
	Private lblAppVersion 	As Label
	Private BtnMenu 		As Label
	Private BtnHide 		As Label
	Private BtnShow 		As Label
	Private BtnExit 		As Button
	Private PnlRoot 		As B4XView
	Private PnlMini 		As B4XView
	Private PnlStatic 		As B4XView
	Private PnlCenter 		As B4XView
	Private ClvMenuMini 	As CustomListView
	Private ClvMenuStatic 	As CustomListView
	Private ClvMenuDrawer 	As CustomListView
	Private CurrentObject	As Object
	#If B4J
	Private FX 				As JFX
	#End If
	Private Title 			As String = "B4XDashboard"
	Private MenuMode		As String = "Mini"
	'Private
	Private lblMiniLabel 	As B4XView
	Private FrostedGlass1 As FrostedGlass
	Private FrostedGlass2 As FrostedGlass
	Private FrostedGlass3 As FrostedGlass
	Private FrostedGlass4 As FrostedGlass
	Private FrostedGlass5 As FrostedGlass
	Private FrostedGlass6 As FrostedGlass
	Private FrostedGlass7 As FrostedGlass
	Private FrostedGlass8 As FrostedGlass
	Private FrostedGlass9 As FrostedGlass
	Private CircularProgressBar1 As CircularProgressBar
	Private CircularProgressBar2 As CircularProgressBar
	Private AnimatedCounter1 As AnimatedCounter
	Private Gauge1 As Gauge
	Private Label2 As B4XView
	Private Label3 As B4XView
	Private Label4 As B4XView
	Private Online As Int = 13562
	Private Sales As Double = 78959
	Private Customers As Int = 635
	Private Messages As Int = 969843
	Private P3D As Object3D
	Private Zoom As Float
	Private centerX As Int
	Private centerY As Int
	Private ModeDraw As Int
	Private Panel As B4XView
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	SetTitle
	InitDrawer
	InitPanel
	InitMenu
	Show(PnlCenter)
	CurrentObject = Me
	#If B4J
	SetButtonMousePointer
	CSSUtils.SetStyleProperty(BtnExit, "-fx-focus-color", "white")
	'CSSUtils.SetStyleProperty(Button1, "-fx-focus-color", "white")
	#End If
	Timer1.Initialize("Timer1", 2000)
	Timer1.Enabled = True
	AnimatedCounter1.Value = Online
	Label2.Text = NumberFormat2(Sales, 1, 0, 0, True)
	Label3.Text = NumberFormat2(Customers, 1, 0, 0, True)
	Label4.Text = NumberFormat2(Messages, 1, 0, 0, True)
	CircularProgressBar1.Value = Rnd(0, 101)
	CircularProgressBar2.Value = Rnd(0, 101)
	Gauge1.SetRanges(Array(Gauge1.CreateRange(70, 80, 0xFFFF6E00), _
	Gauge1.CreateRange(80, 100, XUI.Color_Red)))
	Gauge1.CurrentValue = Rnd(50, 70)
	P3D.Initialize
	Zoom = 1.5
	'ModeDraw 
	'0-Traslucent
	'1-Canvas without depth color 
	'2-BitmapCreator without depth color 10-Automatic (Canvas If less 20mil polygon)
	'3-Canvas with depth color 
	'4-BitmapCreator with depth color 20-Automatic (Canvas If less 20mil polygon)
	ModeDraw = 3
	centerX = Panel.Width/2
	centerY = Panel.Height/2
	LoadFunction3D
	'ApplyQuarkEffect
	'Draw
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Drawer.IsInitialized Then Drawer.Resize(Width, Height)
	'FrostedGlass1.Clear
	FrostedGlass1.Redraw
	FrostedGlass2.Redraw
	FrostedGlass3.Redraw
	FrostedGlass4.Redraw
	FrostedGlass5.Redraw
	FrostedGlass6.Redraw
	FrostedGlass7.Redraw
	FrostedGlass8.Redraw
	FrostedGlass9.Redraw
End Sub

Sub Timer1_Tick
	'Handle tick events
	AnimatedCounter1.Value = Online + Rnd(-5, 6)
	Sales = Sales + Rnd(0, 100) + Rnd(0, 100)/100
	Customers = Customers + Rnd(0, 9)
	Messages = Messages + 1
	Label2.Text = NumberFormat2(Sales, 1, 0, 0, True)
	Label3.Text = NumberFormat2(Customers, 1, 0, 0, True)
	Label4.Text = NumberFormat2(Messages, 1, 0, 0, True)
	CircularProgressBar1.Value = Rnd(0, 101)
	CircularProgressBar2.Value = Rnd(0, 101)
	Gauge1.CurrentValue = Rnd(60, 91) + (Rnd(0, 10) / 10)
	ApplyQuarkEffect
	Draw
End Sub

Private Sub BtnExit_Click
	ExitApplication
End Sub

Sub Draw
	'LogColor("Type Draw:" & ModeDraw, XUI.Color_Red) 
	P3D.Rotate(Null, 0, 0, 0).RenderToView(Panel, centerX, centerY, Zoom, ModeDraw)
	'P3D.Rotate2(Null, 0, 0, 0).RenderToView(Panel, centerX, centerY, Zoom, ModeDraw)
	'Log("Rotate in :" & P3D.Rotatetime)
	'Log("Sort in :" & P3D.SortTime)
	'Log("Draw in :" & P3D.DrawTime)
	'LabelC.Text=$"X:${SeekBarX.Value} Y:${SeekBarY.Value} Z:${SeekBarZ.Value}  Zoom:$1.1{Zoom}"$
End Sub

Sub LoadFunction3D
	Dim ID As Int = 0
	For z = -120 To 120 Step 10
		For x = -120 To 120 Step 10
			Dim NewPointList(2) As Point3D_Type
			Dim y1 As Int = 50 * CosD(z * 2) * SinD(x * 2)
			Dim y2 As Int = 50 * CosD(z * 2) * SinD(x * 2 + 20)
			NewPointList(0) = (P3D.CtP(X, y1, z))
			NewPointList(1) = (P3D.CtP(X + 10, y2, z))
			P3D.AddPolygon(ID, NewPointList, XUI.Color_White, XUI.Color_Transparent)
			ID = ID + 1
		Next
	Next
			
	For x = -120 To 120 Step 10
		For z = -120 To 120 Step 10
			Dim NewPointList(2) As Point3D_Type
			Dim y1 As Int = 50 * CosD(z * 2) * SinD(x * 2)
			Dim y2 As Int = 50* CosD(z * 2 + 20) * SinD(x * 2)
			NewPointList(0) = (P3D.CtP(X, y1, z))
			NewPointList(1) = (P3D.CtP(X, y2, z + 10))
			P3D.AddPolygon(ID, NewPointList, XUI.Color_White, XUI.Color_Transparent)
			ID = ID + 1
		Next
	Next
End Sub

Sub ApplyQuarkEffect
	Sleep(200)
	For Q = 0 To 1080 Step 10
		P3D.clear
		Dim ID As Int = 0
		For z = -120 To 120 Step 10
			For x = -120 To 120 Step 10
				Dim NewPointList(2) As Point3D_Type
				Dim y1 As Int = 50 * CosD(z * 2 + q) * SinD(x * 2)
				Dim y2 As Int = 50 * CosD(z *2 + q) * SinD(x * 2 + 20)
				NewPointList(0) = (P3D.CtP(X, y1, z))
				NewPointList(1) = (P3D.CtP(X + 10, y2, z))
				P3D.AddPolygon(ID, NewPointList, XUI.Color_RGB(190, 190, 255), XUI.Color_Transparent)
				ID = ID + 1
			Next
		Next
				
		For x = -120 To 120 Step 10
			For z = -120 To 120 Step 10
				Dim NewPointList(2) As Point3D_Type
				Dim y1 As Int = 50 * CosD(z * 2 + q) * SinD(x * 2)
				Dim y2 As Int = 50 * CosD(z * 2 + 20 + q) * SinD(x * 2)
				NewPointList(0) = (P3D.CtP(X, y1, z))
				NewPointList(1) = (P3D.CtP(X, y2, z + 10))
				P3D.AddPolygon(ID, NewPointList, XUI.Color_RGB(190, 190, 255), XUI.Color_Transparent)
				ID = ID + 1
			Next
		Next
		P3D.Rotate(Null, 0, 0, 0).RenderToView(Panel, centerX, centerY, Zoom, ModeDraw)
		Sleep(0)
	Next
End Sub

Sub SetTitle
	B4XPages.SetTitle(Me, Title)
End Sub

Sub InitDrawer
	Drawer.Initialize(Me, "Drawer", Root, 300dip)
	Drawer.LeftPanel.LoadLayout("LeftDrawer")
	Drawer.CenterPanel.LoadLayout("MainPanel")
	lblAppVersion.Text = $"A B4X Dashboard${CRLF}   Version ${Main.Version}"$
End Sub

Sub InitPanel
	#If B4A
	ToolbarHelper.Initialize
	ToolbarHelper.ShowUpIndicator = True 'set to true to show the up arrow
	lblAppVersion.Text = $"${Title}${CRLF}Version ${Application.VersionName}"$
	
	Dim bd As BitmapDrawable
	bd.Initialize(LoadBitmap(File.DirAssets, "img_hamburger.png"))
	ToolbarHelper.UpIndicatorDrawable =  bd
	ACToolBarLight1.InitMenuListener
	#End If
	#If B4i
	lblAppVersion.Text = $"${Title}${CRLF}Version ${Main.Version}"$
	#End If
	#If B4J
	LblTitle.Text = Title
	PnlMini.LoadLayout("PanelMini")
	PnlStatic.LoadLayout("PanelStatic")
	lblAppVersion.Text = $"A B4X Dashboard${CRLF}   Version ${Main.Version}"$
	'CSSUtils.SetStyleProperty(Button1, "-fx-focus-color", "white")
	Select MenuMode
		Case "Mini"
			PnlMini.Visible = True
			PnlStatic.Visible = False
			PnlCenter.Width = PnlRoot.Width - PnlMini.Width
			PnlCenter.Left = 60dip
		Case "Static"
			PnlMini.Visible = False
			PnlStatic.Visible = True
			PnlCenter.Width = PnlRoot.Width - PnlStatic.Width
			PnlCenter.Left = PnlStatic.Left + PnlStatic.Width
		Case Else
			PnlMini.Visible = False
			PnlStatic.Visible = False
			PnlCenter.Width = PnlRoot.Width
			PnlCenter.Left = 0
	End Select
	#End If
	'BtnExit.Visible = False	' If MainForm.FormStyle = "UNDECORATED"
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuMini, XUI.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuStatic, XUI.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuDrawer, XUI.Color_Transparent)
End Sub

#If B4J
Sub BtnMenu_MouseClicked (EventData As MouseEvent)
#Else
Sub BtnMenu_Click
#End If
	Select MenuMode
		Case "Mini", "Static"
			SwitchMenu
		Case Else
			Drawer.LeftOpen = Not(Drawer.LeftOpen)
	End Select
End Sub

Sub ACToolBarLight1_NavigationItemClick
	Drawer.LeftOpen = Not(Drawer.LeftOpen)
End Sub

Private Sub BtnHide_MouseClicked (EventData As MouseEvent)
	MenuMode = "Drawer"
	PnlMini.Visible = False
	PnlStatic.Visible = False
	PnlCenter.Width = Root.Width
	PnlCenter.Left = 0
	'If Drawer.IsInitialized Then Drawer.Resize(Root.Width, Root.Height)
	LoadPage(CurrentObject)
End Sub

Private Sub BtnShow_MouseClicked (EventData As MouseEvent)
	Drawer.LeftOpen = False
	MenuMode = "Static"
	PnlStatic.Visible = True
	PnlMini.Visible = False
	PnlCenter.Width = Root.Width - PnlStatic.Width
	PnlCenter.Left = PnlStatic.Left + PnlStatic.Width
	LoadPage(CurrentObject)
End Sub

Sub Drawer_StateChanged (Open As Boolean)
	If Open Then

	Else

	End If
End Sub

Private Sub Show (Parent As B4XView)
	If mBase.IsInitialized = False Then
		mBase = XUI.CreatePanel("")
		mBase.LoadLayout("Dashboard")
	End If
	mBase.RemoveViewFromParent
	Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
	'CSSUtils.SetStyleProperty(Button1, "-fx-focus-color", "white")
End Sub

Private Sub ContentEmpty As Boolean
	Return PnlCenter.NumberOfViews = 0
End Sub

Private Sub LoadPage (Value As Object)
	If ContentEmpty = False Then PnlCenter.GetView(0).RemoveViewFromParent
	CallSub2(Value, "Show", PnlCenter)
	CurrentObject = Value
	' UI fix begin
	Sleep(50)
	FrostedGlass3.Redraw
	FrostedGlass6.Redraw
	' UI fix end
End Sub

Private Sub ClvMenuStatic_ItemClick (Index As Int, Value As Object)
	LoadPage(Value)
End Sub

Private Sub ClvMenuMini_ItemClick (Index As Int, Value As Object)
	LoadPage(Value)
End Sub

Private Sub ClvMenuDrawer_ItemClick (Index As Int, Value As Object)
	LoadPage(Value)
	Drawer.LeftOpen = False
End Sub

Sub SwitchMenu
	Select MenuMode
		Case "Mini"
			MenuMode = "Static"
			PnlStatic.Visible = True
			PnlMini.Visible = False
			PnlCenter.Width = Root.Width - PnlStatic.Width
			PnlCenter.Left = PnlStatic.Left + PnlStatic.Width
		Case "Static"
			MenuMode = "Mini"
			PnlStatic.Visible = False
			PnlMini.Visible = True
			PnlCenter.Width = Root.Width - PnlMini.Width
			PnlCenter.Left = PnlMini.Left + PnlMini.Width
	End Select
	LoadPage(CurrentObject)
End Sub

Public Sub InitMenu
	ClvMenuDrawer.Clear
	Dim frm1 As Form1
	Dim frm2 As Form2
	frm1.Initialize
	frm2.Initialize
	ClvMenuDrawer.AddTextItem("Dashboard", Me)
	ClvMenuDrawer.AddTextItem("Form1", frm1)
	ClvMenuDrawer.AddTextItem("Form2", frm2)
	
	ClvMenuStatic.AddTextItem("Dashboard", Me)
	ClvMenuStatic.AddTextItem("Form1", frm1)
	ClvMenuStatic.AddTextItem("Form2", frm2)
	
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF015), ClvMenuMini.AsView.Width), Me)
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF004), ClvMenuMini.AsView.Width), frm1)
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF06B), ClvMenuMini.AsView.Width), frm2)
End Sub

Sub CreateMiniItem (Text As String, Width As Int) As B4XView
	Dim pnl As B4XView = XUI.CreatePanel("")
	'pnl.Color = XUI.Color_Transparent
	pnl.SetLayoutAnimated(0, 0, 0, Width, 60dip)
	pnl.LoadLayout("MiniItem")
	lblMiniLabel.Text = Text
	#If B4J
	pnl.As(Pane).MouseCursor = FX.Cursors.HAND
	#End If
	Return pnl
End Sub

#If B4J
' B4J specific UI
Private Sub SetScrollPaneBackgroundColor (View As CustomListView, Color As Int)
	Dim SP As JavaObject = View.GetBase.GetView(0)
	Dim V As B4XView = SP
	V.Color = Color
	Dim V As B4XView = SP.RunMethod("lookup", Array(".viewport"))
	V.Color = Color
End Sub

Private Sub SetButtonMousePointer
	BtnMenu.MouseCursor = FX.Cursors.HAND
	BtnExit.MouseCursor = FX.Cursors.HAND
	BtnHide.MouseCursor = FX.Cursors.HAND
	BtnShow.MouseCursor = FX.Cursors.HAND
End Sub
#End If