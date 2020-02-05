using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class atomicAttraction : MonoBehaviour {

    public OSC osc;

    public GameObject _atom, _attractTo;
    public Gradient _gradient;

    public Material _material;
    public int[] _attractToPoints;
    public Vector3 _spacing;
    [
        Range (0, 20)
    ]
    public float _spacingBtwnAttractions;
    [Range (0, 20)]
    public float _scaleAttractions;
    GameObject[] _attractToArr, _atomArr;
    [Range (1, 64)]
    public int _numberOfAtoms;

    public Vector2 _atomScaleMinMax;
    float[] _atomScaleSet;

    public float _strengthOfAttraction, _maxMagnitude, _randomPosDist;
    public bool _useGravity;

    Material[] _sharedMaterial;
    Color[] _sharedColor;

    /* Audio Changes*/
    public float _audioScaleMult, _audioEmissionmult;

    [Range (0.0f, 1.0f)]
    public float _threshold;

    float[] _audioBandEmissionThreshold;
    float[] _audioBandEmissionColor;
    float[] _audioBandScale;

    public enum _emmisionThreshold {
        Buffered,
        NoBuffer
    }
    public _emmisionThreshold emmisionThreshold = new _emmisionThreshold ();

    public enum _emmisionColor {
        Buffered,
        NoBuffer
    }
    public _emmisionColor emmisionColor = new _emmisionColor ();

    public enum _emmisionScale {
        Buffered,
        NoBuffer
    }
    public _emmisionScale emmisionScale = new _emmisionScale ();

    public bool _animationLoc;
    Vector3 _startPoint;
    public Vector3 _destination;
    public AnimationCurve _animCurve;
    float _animTimer;
    public int _posAnimBand;
    public bool _posAnimBuffered;

    private void OnDrawGizmos () {
        for (int i = 0; i < _attractToPoints.Length; i++) {
            // float evaluateStep = 1.0f / _attractToPoints.Length;
            float evaluateStep = 0.125f;
            Color color = _gradient.Evaluate (Mathf.Clamp (evaluateStep * _attractToPoints[i], 0, 7));
            Gizmos.color = color;
            // Debug.Log("Whyyyyyyyyy!!!!!!!!!!" );
            Vector3 position = new Vector3 (transform.position.x + (_spacingBtwnAttractions * i * _spacing.x),
                transform.position.y + (_spacingBtwnAttractions * i * _spacing.y),
                transform.position.z + (_spacingBtwnAttractions * i * _spacing.z));

            Gizmos.DrawSphere (position, _scaleAttractions * 0.5f);
        }

    }

    void OnReceiveXYZ (OscMessage message) {
        _strengthOfAttraction = message.GetInt (0);
        _audioEmissionmult = message.GetInt (1);
        int r = message.GetInt(2);
        int g = message.GetInt(3);
        int b = message.GetInt(4);
        // int z = message.GetInt (2);

        int countAtom = 0;
        for (int i = 0; i < _attractToPoints.Length; i++) {

            for (int j = 0; j < _numberOfAtoms; j++) {

                _atomArr[countAtom].GetComponent<attractTo> ()._strength = _strengthOfAttraction;

                countAtom++;
            }
            _sharedColor[i].r = (float)r/256f;
            _sharedColor[i].g = (float)g/256f;
            _sharedColor[i].b = (float)b/256;

        }
    }

    // Start is called before the first frame update
    void Start () {
        osc.SetAddressHandler ("/CubeXYZ", OnReceiveXYZ);
        instantiateAttraction ();
    }

    void instantiateAttraction () {
        _attractToArr = new GameObject[_attractToPoints.Length];
        _atomArr = new GameObject[_attractToPoints.Length * _numberOfAtoms];
        _atomScaleSet = new float[_attractToPoints.Length * _numberOfAtoms];
        _sharedMaterial = new Material[8];
        _sharedColor = new Color[8];

        _audioBandEmissionThreshold = new float[8];
        _audioBandEmissionColor = new float[8];
        _audioBandScale = new float[8];
        int countAtom = 0;
        for (int i = 0; i < _attractToPoints.Length; i++) {
            GameObject _attractorInstance = (GameObject) Instantiate (_attractTo);
            createAttr (i, _attractorInstance);
            for (int j = 0; j < _numberOfAtoms; j++) {
                GameObject _atomInstance = (GameObject) Instantiate (_atom);
                createAtoms (i, countAtom, _atomInstance);
                countAtom++;
            }
        }
    }

    void createAtoms (int i, int currCount, GameObject _atomInstance) {
        _atomArr[currCount] = _atomInstance;
        _atomInstance.GetComponent<attractTo> ()._attractedTo = _attractToArr[i].transform;
        _atomInstance.GetComponent<attractTo> ()._strength = _strengthOfAttraction;
        _atomInstance.GetComponent<attractTo> ()._maxStrength = _maxMagnitude;

        if (_useGravity) {
            _atomInstance.GetComponent<Rigidbody> ().useGravity = true;
        } else {
            _atomInstance.GetComponent<Rigidbody> ().useGravity = false;
        }

        _atomInstance.transform.position = new Vector3 (_attractToArr[i].transform.position.x + Random.Range (-_randomPosDist, _randomPosDist),
            _attractToArr[i].transform.position.y + Random.Range (-_randomPosDist, _randomPosDist),
            _attractToArr[i].transform.position.z + Random.Range (-_randomPosDist, _randomPosDist));

        float _randomScale = Random.Range (_atomScaleMinMax.x, _atomScaleMinMax.y);
        _atomScaleSet[currCount] = _randomScale;
        _atomInstance.transform.localScale = new Vector3 (_atomScaleSet[currCount], _atomScaleSet[currCount], _atomScaleSet[currCount]);
        // _atomInstance.transform.parent = this.transform;;
        // _atomInstance.transform.parent = _attractorInstance.transform;;

        _atomInstance.GetComponent<MeshRenderer> ().material = _sharedMaterial[i];
        // _atomInstance.GetComponent<Renderer> ().material.SetColor ("_EmissionColor", _sharedColor[i]);

    }
    void createAttr (int i, GameObject _attractorInstance) {
        _attractToArr[i] = _attractorInstance;
        _attractorInstance.transform.position = new Vector3 (
            transform.position.x + (_spacingBtwnAttractions * i * _spacing.x),
            transform.position.y + (_spacingBtwnAttractions * i * _spacing.y),
            transform.position.z + (_spacingBtwnAttractions * i * _spacing.z));

        _attractorInstance.transform.parent = this.transform;
        _attractorInstance.transform.localScale = new Vector3 (_scaleAttractions, _scaleAttractions, _scaleAttractions);

        // Set Color and material
        Material _matInstance = new Material (_material);
        _sharedMaterial[i] = _matInstance;
        _sharedColor[i] = _gradient.Evaluate (0.125f * i);
    }

    // Update is called once per frame
    void Update () {
        selectAudioValues ();
        atomBehaviour ();
    }

    void atomBehaviour () {
        int countAtom = 0;
        for (int i = 0; i < _attractToPoints.Length; i++) {
            if (_audioBandEmissionThreshold[_attractToPoints[i]] >= _threshold) {
                Color _audioColor = new Color (_sharedColor[i].r * _audioBandEmissionColor[_attractToPoints[i]] * _audioEmissionmult,
                    _sharedColor[i].g * _audioBandEmissionColor[_attractToPoints[i]] * _audioEmissionmult,
                    _sharedColor[i].b * _audioBandEmissionColor[_attractToPoints[i]] * _audioEmissionmult, 1
                );
                _sharedMaterial[i].SetColor ("_EmissionColor", _audioColor);

            } else {
                Color _audioColor = new Color (0, 0, 0, 1);
                _sharedMaterial[i].SetColor ("_EmissionColor", _audioColor);
            }

            for (int j = 0; j < _numberOfAtoms; j++) {

                _atomArr[countAtom].transform.localScale = new Vector3 (_atomScaleSet[countAtom] + _audioBandScale[_attractToPoints[i]] * _audioScaleMult,
                    _atomScaleSet[countAtom] + _audioBandScale[_attractToPoints[i]] * _audioScaleMult,
                    _atomScaleSet[countAtom] + _audioBandScale[_attractToPoints[i]] * _audioScaleMult);
                countAtom++;
            }
        }
    }

    void selectAudioValues () {
        if (emmisionThreshold == _emmisionThreshold.Buffered) {
            for (int i = 0; i < 8; i++) {
                // print(AudioPeer._audioBandBuffer[i]);

                _audioBandEmissionThreshold[i] = AudioPeer._audioBandBuffer[i];
            }
        }
        if (emmisionThreshold == _emmisionThreshold.NoBuffer) {
            for (int i = 0; i < 8; i++) {
                _audioBandEmissionThreshold[i] = AudioPeer._audioBand[i];
            }
        }

        if (emmisionColor == _emmisionColor.Buffered) {
            for (int i = 0; i < 8; i++) {
                _audioBandEmissionColor[i] = AudioPeer._audioBandBuffer[i];
            }
        }
        if (emmisionColor == _emmisionColor.NoBuffer) {
            for (int i = 0; i < 8; i++) {
                _audioBandEmissionColor[i] = AudioPeer._audioBand[i];
            }
        }

        if (emmisionScale == _emmisionScale.Buffered) {
            for (int i = 0; i < 8; i++) {
                _audioBandScale[i] = AudioPeer._audioBandBuffer[i];
            }
        }
        if (emmisionScale == _emmisionScale.NoBuffer) {
            for (int i = 0; i < 8; i++) {
                _audioBandScale[i] = AudioPeer._audioBand[i];
            }
        }
    }
}