using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class attractTo : MonoBehaviour
{

    Rigidbody  _rigidBody;
    public Transform _attractedTo;
    public float _strength, _maxStrength;
    // Start is called before the first frame update
    void Start()
    {
        _rigidBody = GetComponent <Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if(_attractedTo != null ){
            Vector3 dir = _attractedTo.position - transform.position;
            _rigidBody.AddForce(_strength * dir);
        }

        if(_rigidBody.velocity.magnitude > _maxStrength){
                _rigidBody.velocity = _rigidBody.velocity.normalized * _maxStrength;
        }
        
    }
}
