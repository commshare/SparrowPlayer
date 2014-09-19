package com.xinguoedu.v.base
{
	import com.greensock.TweenLite;
	import com.xinguoedu.consts.PlayerColor;
	import com.xinguoedu.evt.EventBus;
	import com.xinguoedu.evt.PlayerStateEvt;
	import com.xinguoedu.m.Model;
	import com.xinguoedu.utils.ShapeFactory;
	import com.xinguoedu.utils.StageReference;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 * 可显示组件的基类 
	 * @author yatsen_yang
	 * 
	 */	
	public class BaseComponent extends Sprite
	{
		protected var _m:Model;
		/** 组件对应的皮肤 **/
		protected var _skin:MovieClip;		
		/** 关闭按钮 **/
		protected var _closeBtn:Sprite;
		private var _defaultShape:Shape;
		private var _overShape:Shape;
		/** 关闭按钮tweenlite对象的引用 **/
		private var _tweenLite:TweenLite;
		
		public function BaseComponent(m:Model)
		{
			super();			
			this._m = m;		
			buildUI();
			addListeners();
		}
		
		protected function buildUI():void
		{
			
		}
		
		protected function addListeners():void
		{
			StageReference.stage.addEventListener(Event.RESIZE, resizeHandler);
			EventBus.getInstance().addEventListener(PlayerStateEvt.PLAYER_STATE_CHANGE, playerStateChangeHandler);
		}
		
		private function resizeHandler(evt:Event):void
		{
			resize();
		}
		
		/** 交给子类重写 **/
		protected function playerStateChangeHandler(evt:PlayerStateEvt):void
		{
			
		}
		
		protected function getSkinComponent(skin:MovieClip, compName:String):DisplayObject
		{
			return skin.getChildByName(compName);
		}
		
		/** 交给子类重写 **/
		protected function resize():void
		{
			
		}
		
		/**
		 * 舞台宽度
		 * @return 
		 * 
		 */		
		protected function get stageWidth():Number
		{
			return StageReference.stage.stageWidth;
		}
		
		/**
		 * 舞台高度
		 * @return 
		 * 
		 */		
		protected function get stageHeight():Number
		{
			return StageReference.stage.stageHeight;
		}
		
		/**
		 * StageDisplayState 
		 * @return 
		 * 
		 */		
		protected function get displayState():String
		{
			return StageReference.stage.displayState;
		}
		
		protected function drawCloseBtn():void
		{
			_defaultShape = ShapeFactory.getShapeByColor(PlayerColor.MAIN_BG);
			_defaultShape.name = "default";
			
			_overShape = ShapeFactory.getShapeByColor(PlayerColor.MAIN_COLOR);
			_overShape.name = "over";
			
			_closeBtn = new Sprite();
			_closeBtn.mouseChildren = false;
			_closeBtn.buttonMode = true;
			_closeBtn.filters = [new GlowFilter(PlayerColor.GLOW_FILTER_COLOR,1,8.0,8.0)];					
			_closeBtn.name = "close";
			_closeBtn.addChild(_overShape);
			_overShape.visible = false;
			_closeBtn.addChild(_defaultShape);
			_closeBtn.addEventListener(MouseEvent.MOUSE_OVER, overCloseBtnHandler);
			_closeBtn.addEventListener(MouseEvent.MOUSE_OUT, outCloseBtnHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK, clickCloseBtnHandler);			
			addChild(_closeBtn);
		}
		
		private function overCloseBtnHandler(evt:MouseEvent):void
		{
			evt.stopPropagation();
			_overShape.visible = true;		
			_defaultShape.visible = false;
			destroyTween();			
			_tweenLite = TweenLite.from(_overShape, 0.3,{rotation:-90}); //旋转效果			
		}
		
		private function outCloseBtnHandler(evt:MouseEvent):void
		{
			evt.stopPropagation();
			destroyTween();			
			_overShape.visible = false;
			_defaultShape.visible = true;
		}
		
		protected function clickCloseBtnHandler(evt:MouseEvent):void
		{			
			evt.stopPropagation();
			hide();
		}
		
		/** 隐藏自己 **/
		protected function hide():void
		{
			visible = false;
		}
		
		private function destroyTween():void
		{
			if(_tweenLite != null)
			{
				TweenLite.killTweensOf(_tweenLite, true);
				_tweenLite = null;
			}
		}
		
	}
}