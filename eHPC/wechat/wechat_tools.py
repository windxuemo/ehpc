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
    encodingAESKey = "hMjrwWo4IvQ12gyGA9JUVLsVi94OG8tGyI8FjTovxCT"
    appid = "wxf358191ee7bd4d7b"
    token = "ehpcshixiong666"

    def __init__(self):
        self.message = Message()

    def __repr__(self):
        return u"ToUserName: %s\nFromUserName: %s\n" \
               u"CreateTime: %s\nMsgType: %s\nContent: %s\nMsgId: %s\n".encode("utf8") \
               % (self.message.ToUserName.encode("utf8"), self.message.FromUserName.encode("utf8"),
                  self.message.CreateTime.encode("utf8"), self.message.MsgType.encode("utf8"),
                  self.message.Content.encode("utf8"), self.message.MsgId.encode("utf8"))

    def check_signature(self, signature, timestamp, nonce):
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
        decryption = WXBizMsgCrypt(cls.token, cls.encodingAESKey, cls.appid)
        result, real_xml = decryption.DecryptMsg(xml, msg_signature, timestamp, nonce)
        return real_xml

    @classmethod
    def encrypt(cls, xml, nonce):
        encryption = WXBizMsgCrypt(cls.token, cls.encodingAESKey, cls.appid)
        result, encrypt_xml = encryption.EncryptMsg(xml, nonce)
        return encrypt_xml

    def xml_to_self(self, xml):
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
        temp = []
        for k, v in data.items():
            temp.append("<%s><![CDATA[%s]]></%s>" % (k, v, k))
        return "\n".join(temp)

    @classmethod
    def prepare_to_response(cls, ToUserName, FromUserName, CreateTime, MsgType, Content, nonce):
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
