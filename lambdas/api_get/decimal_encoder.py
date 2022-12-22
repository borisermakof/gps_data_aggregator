import json
from decimal import Decimal

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        """
        Converts Decimal type to float
         
        Args:
            obj (param) - param to deserialize"""
        if isinstance(obj, Decimal):
            return float(obj)

        return json.JSONEncoder.default(self, obj)