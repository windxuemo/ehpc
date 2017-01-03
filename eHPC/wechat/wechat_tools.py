#! /usr/bin/env python
# -*- coding: utf-8 -*-

import hashlib
from WXBizMsgCrypt import WXBizMsgCrypt
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET


class WechatException(Exception):
    pass


class Message(object):
    def __init__(self):
        self.ToUserName = None
        self.FromUserName = None
        self.CreateTime = None
        self.MsgType = None
        self.MsgId = None
        self.Content = None


class Wechat(object):
    encodingAESKey = "hMjrwWo4IvQ12gyGA9JUVLsVi94OG8tGyI8FjTovxCT"  # 微信端加密时使用的AES密钥(需保密)
    appid = "wxf358191ee7bd4d7b"  # 公众号appid(需保密)
    token = "ehpcshixiong666"  # 微信公众号端身份验证唯一凭证(需保密)

    def __init__(self):
        self.message = Message()

    def __repr__(self):
        return u"ToUserName: %s\nFromUserName: %s\n" \
               u"CreateTime: %s\nMsgType: %s\nContent: %s\nMsgId: %s\n".encode("utf8") \
               % (self.message.ToUserName.encode("utf8"), self.message.FromUserName.encode("utf8"),
                  self.message.CreateTime.encode("utf8"), self.message.MsgType.encode("utf8"),
                  self.message.Content.encode("utf8"), self.message.MsgId.encode("utf8"))

    def check_signature(self, signature, timestamp, nonce):
        """验证发送方身份是否合法
        @param self:  实例本身
        @param signature: 微信发来数据中携带的签名
        @param timestamp: 时间戳
        @param nonce: 随机字符串
        @return: 是否验证成功
        """
        if not isinstance(timestamp, (str, unicode)):
            timestamp = str(timestamp)
        if self.token is None:
            raise WechatException("self.token is None")
        my_signature = [timestamp, self.token, nonce]
        my_signature.sort()
        my_signature = hashlib.sha1("".join(my_signature)).hexdigest()
        if my_signature == signature:
            return True
        else:
            return False

    @classmethod
    def decrypt(cls, xml, msg_signature, timestamp, nonce):
        """类函数，用于解密微信发来的数据
        @param cls:  类本身
        @param xml: 微信发来的xml数据
        @param msg_signature: 消息签名
        @param timestamp: 时间戳
        @nonce: 随机字符串
        @return: 解密后的数据
        """
        decryption = WXBizMsgCrypt(cls.token, cls.encodingAESKey, cls.appid)
        result, real_xml = decryption.DecryptMsg(xml, msg_signature, timestamp, nonce)
        return real_xml

    @classmethod
    def encrypt(cls, xml, nonce):
        """类函数，用于加密微信发来的数据
        @param cls:  类本身
        @param xml: 需加密的xml数据
        @nonce: 随机字符串
        @return: 加密后的数据
        """
        encryption = WXBizMsgCrypt(cls.token, cls.encodingAESKey, cls.appid)
        result, encrypt_xml = encryption.EncryptMsg(xml, nonce)
        return encrypt_xml

    def xml_to_self(self, xml):
        """将xml数据内容按固定方式复制到实例属性中
        @param self:  实例本身
        @param xml: xml数据
        """
        root = ET.fromstring(xml)
        temp = {}
        for e in root:
            temp[e.tag] = e.text
        self.message.ToUserName = temp['ToUserName']
        self.message.FromUserName = temp['FromUserName']
        self.message.CreateTime = temp['CreateTime']
        self.message.MsgType = temp['MsgType']
        self.message.MsgId = temp['MsgId']
        self.message.Content = temp['Content']

    @classmethod
    def to_xml(cls, data):
        """将字典格式数据转化成微信要求的xml格式
           @param cls:  类本身
           @param data: 字典格式数据
        """
        temp = []
        for k, v in data.items():
            temp.append("<%s><![CDATA[%s]]></%s>" % (k, v, k))
        return "\n".join(temp)

    @classmethod
    def prepare_to_response(cls, ToUserName, FromUserName, CreateTime, MsgType, Content, nonce):
        """按要求生成待发送至微信服务器的数据(目前只支持文本类型)
           @param cls:  类本身
           @param ToUserName: 接收方
           @param FromUserName: 发送方
           @param CreateTime: 发送时间
           @param MsgType: 消息类型
           @param Content: 消息内容
           @param nonce: 随机字符串
        """
        response_data = {
            "ToUserName": ToUserName,
            "FromUserName": FromUserName,
            "CreateTime": CreateTime,
            "MsgType": MsgType,
            "Content": Content
        }
        response_data = cls.to_xml(response_data)
        response_data = "<xml>\n" + response_data + "\n</xml>"
        cls.encrypt(xml=response_data, nonce=nonce)
        return response_data
